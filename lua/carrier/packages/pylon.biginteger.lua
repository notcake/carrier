local OOP    = require ("Pylon.OOP")
local UInt24 = require ("Pylon.UInt24")

local self = {}
local BigInteger = OOP.Class (self)

local tonumber      = tonumber

local bit_band      = bit.band
local bit_lshift    = bit.lshift
local bit_rshift    = bit.rshift
local math_floor    = math.floor
local math_log      = math.log
local math_max      = math.max
local string_byte   = string.byte
local string_char   = string.char
local string_format = string.format
local string_sub    = string.sub
local table_concat  = table.concat

local UInt24_Maximum            = UInt24.Maximum
local UInt24_BitCount           = UInt24.BitCount

local UInt24_Add                = UInt24.Add
local UInt24_AddWithCarry       = UInt24.AddWithCarry
local UInt24_MultiplyAdd2       = UInt24.MultiplyAdd2
local UInt24_Subtract           = UInt24.Subtract
local UInt24_SubtractWithBorrow = UInt24.SubtractWithBorrow
local UInt24_CountLeadingZeros  = UInt24.CountLeadingZeros

function BigInteger.FromBlob (data)
	local n = BigInteger ()
	
	n [1] = nil
	for i = #data - 2, 1, -3 do
		local c0, c1, c2 = string_byte (data, i, i + 2)
		n [#n + 1] = c0 * 0x00010000 + c1 * 0x00000100 + c2
	end
	
	if #data % 3 ~= 0 then
		local c = 0
		for i = 1, #data % 3 do
			c = c * 0x0100
			c = c + string_byte (data, i)
		end
		n [#n + 1] = c
	end
	
	-- Normalize
	n:Normalize ()
	
	return n
end

function BigInteger.FromDecimal (str)
	local n = BigInteger ()
	
	-- Convert to decimal bignum
	local d = {}
	for i = #str - 7, 1, -8 do
		d [#d + 1] = tonumber (string_sub (str, i, i + 7))
	end
	
	if #str % 8 ~= 0 then
		d [#d + 1] = tonumber (string_sub (str, 1, #str % 8))
	end
	
	-- Normalize
	for i = #d, 1, -1 do
		if d [i] ~= 0 then break end
		
		d [i] = nil
	end
	
	-- Strip off hex digits in groups of 6
	n [1] = nil
	repeat
		local remainder = 0
		for i = #d, 1, -1 do
			local a = d [i] + remainder * 100000000
			d [i], remainder = math_floor (a / 0x01000000), bit_band (a, 0x00FFFFFF)
		end
		
		n [#n + 1] = remainder
		
		-- Normalize
		if d [#d] == 0 then
			d [#d] = nil
		end
	until #d == 0
	
	return n
end

function BigInteger.FromHex (str)
	local n = BigInteger ()
	
	n [1] = nil
	for i = #str - 5, 1, -6 do
		n [#n + 1] = tonumber (string_sub (str, i, i + 5), 16)
	end
	
	if #str % 6 ~= 0 then
		n [#n + 1] = tonumber (string_sub (str, 1, #str % 6), 16)
	end
	
	-- Normalize
	n:Normalize ()
	
	return n
end

function BigInteger.FromUInt8 (x)
	local n = BigInteger ()
	n [1] = x
	return n
end

function BigInteger.FromUInt32 (x)
	local n = BigInteger ()
	n [1] = bit_band (x, 0x00FFFFFF)
	n [2] = bit_rshift (x, 24)
	n [2] = n [2] ~= 0 and n [2] or nil
	return n
end

function self:ctor ()
	self [1] = 0
end

function self:GetBitCount ()
	local leadingBitCount = 1 + math_floor (math_log (self [#self]) / math_log (2))
	leadingBitCount = math_max (0, leadingBitCount)
	local bitCount = (#self - 1) * UInt24.BitCount
	return bitCount + leadingBitCount
end

function self:IsZero ()
	return #self == 1 and self [1] == 0
end

function self:Add (b, out)
	local out = out or BigInteger ()
	local a = self
	
	if #b > #a then
		a, b = b, a
	end
	
	local cf = 0
	for i = 1, #b do
		out [i], cf = UInt24.AddWithCarry (a [i], b [i], cf)
	end
	
	for i = #b + 1, #a do
		out [i], cf = UInt24.Add (a [i], cf)
	end
	
	-- Clear
	out:Truncate (#a + 1)
	
	-- Carry
	out [#a + 1] = cf > 0 and cf or nil
	
	return out
end

function self:Clone (out)
	local out = out or BigInteger ()
	
	for i = 1, #self do
		out [i] = self [i]
	end
	
	out:Truncate (#self)
	
	return out
end

function self:Multiply (b, out)
	local out = out or BigInteger ()
	local a = self
	
	-- Prepare for convolution
	out:TruncateAndZero (#a + #b)
	
	-- Multiply
	for i = 1, #a do
		local high = 0
		for j = 1, #b do
			out [i + j - 1], high = UInt24.MultiplyAdd2 (a [i], b [j], out [i + j - 1], high)
		end
		
		-- Carry
		for j = i + #b, #a + #b do
			out [j], high = UInt24.Add (out [j], high)
			if high == 0 then break end
		end
	end
	
	out:Normalize ()
	
	return out
end

function self:MultiplySmall (b, out)
	local out = out or BigInteger ()
	local a = self
	
	local high = 0
	for i = 1, #a do
		out [i], high = UInt24.MultiplyAdd1 (a [i], b, high)
	end
	
	-- Clear
	out:Truncate (#a + 1)
	
	-- Carry
	out [#a + 1] = high
	
	-- Normalize
	out:Normalize ()
	
	return out
end

function self:Divide (b, out1, out2)
	if #b == 1 then
		local quotient, remainder = self:DivideSmall (b [1], out1)
		return quotient, BigInteger.FromUInt32 (remainder)
	end
	local quotient  = out1 or BigInteger ()
	local remainder = self:Clone (out2)
	local a = self
	
	quotient:TruncateAndZero (#a - #b + 1)
	
	-- HACK: Pull in 25 bits of divisor to calculate the quotient
	local additionalBitCount = UInt24_CountLeadingZeros (b [#b]) + 1
	local d = b [#b] * bit_lshift (1, additionalBitCount) + bit_rshift (b [#b - 1], UInt24.BitCount - additionalBitCount)
	
	for i = #a - #b + 1, 1, -1 do
		local r1 = remainder [i + #b] or 0
		local r0 = remainder [i + #b - 1]
		
		-- HACK: Pull in 25 bits of divisor to calculate the quotient
		local r = (r1 * (UInt24_Maximum + 1) + r0) * bit_lshift (1, additionalBitCount) + bit_rshift (remainder [i + #b - 2], UInt24_BitCount - additionalBitCount)
		local q = math_floor (r / d)
		
		local p0, p1 = 0, 0
		local borrow = 0
		for j = 1, #b do
			p0, p1 = UInt24_MultiplyAdd2 (b [j], q, p1, borrow)
			remainder [i + j - 1], borrow = UInt24_Subtract (remainder [i + j - 1], p0)
		end
		
		remainder [i + #b], borrow = UInt24_SubtractWithBorrow (remainder [i + #b] or 0, p1, borrow)
		
		if borrow > 0 then
			q = q - 1
			
			local carry = 0
			for j = 1, #b do
				remainder [i + j - 1], carry = UInt24_AddWithCarry (remainder [i + j - 1], b [j], carry)
			end
			remainder [i + #b] = UInt24_Add (remainder [i + #b], carry)
		end
		
		quotient [i] = q
	end
	
	-- Normalize remainder
	remainder:Normalize ()
	
	return quotient, remainder
end

function self:DivideSmall (b, out)
	local out = out or BigInteger ()
	local a = self
	
	-- Clear
	out:Truncate (#a)
	
	-- Divide
	local remainder = 0
	for i = #a, 1, -1 do
		out [i], remainder = UInt24.Divide (a [i], remainder, b)
	end
	
	-- Normalize
	out:Normalize ()
	
	return out, remainder
end

function self:ExponentiateSmall (exponent)
	local out = BigInteger.FromUInt32 (1)
	
	local factor = self:Clone ()
	local mask = 1
	while mask <= exponent do
		if bit_band (exponent, mask) ~= 0 then
			out = out:Multiply (factor)
		end
		
		mask = mask * 2
		factor = factor:Multiply (factor)
	end
	
	return out
end

function self:ExponentiateMod (exponent, mod)
	local out = BigInteger.FromUInt32 (1)
	
	local factor = self:Clone ()
	for i = 1, #exponent do
		local mask = 1
		for j = 1, UInt24.BitCount do
			if bit_band (exponent [i], mask) ~= 0 then
				out = out:Multiply (factor):Mod (mod)
			end
			
			mask = mask * 2
			factor = factor:Multiply (factor):Mod (mod)
		end
	end
	
	return out
end

function self:Mod (b, out1, out2)
	local quotient, remainder = self:Divide (b, out1, out2)
	return remainder, quotient
end

function self:ModSmall (b)
	local a = self
	
	-- Divide
	local _, remainder = UInt24.Divide (a [#a], 0, b)
	for i = #a - 1, 1, -1 do
		_, remainder = UInt24.Divide (a [i], remainder, b)
	end
	
	return remainder
end

function self:ToBlob ()
	local t = {}
	
	-- Format start
	local x = self [#self]
	local c0 = bit_rshift (x, 16)
	local c1 = bit_band (bit_rshift (x, 8), 0xFF)
	local c2 = bit_band (x, 0xFF)
	
	if c0 > 0 then
		t [#t + 1] = string_char (c0, c1, c2)
	elseif c1 > 0 then
		t [#t + 1] = string_char (c1, c2)
	else
		t [#t + 1] = string_char (c2)
	end
	
	-- Format rest
	for i = #self - 1, 1, -1 do
		local x = self [i]
		local c0 = bit_rshift (x, 16)
		local c1 = bit_band (bit_rshift (x, 8), 0xFF)
		local c2 = bit_band (x, 0xFF)
		
		t [#t + 1] = string_char (c0, c1, c2)
	end
	
	return table_concat (t)
end

function self:ToDecimal ()
	local n = self:Clone ()
	
	-- Strip off digits in groups of 7
	local t = {}
	repeat
		n, t [#t + 1] = n:DivideSmall (10000000, n)
	until n:IsZero ()
	
	-- Reverse
	for i = 1, #t / 2 do
		t [i], t [#t - i + 1] = t [#t - i + 1], t [i]
	end
	
	-- Format
	t [1] = tonumber (t [1])
	for i = 2, #t do
		t [i] = string_format ("%07d", t [i])
	end
	
	return table_concat (t)
end

function self:ToHex ()
	local t = {}
	
	-- Format
	t [#t + 1] = string_format ("%x", self [#self])
	for i = #self - 1, 1, -1 do
		t [#t + 1] = string_format ("%06x", self [i])
	end
	
	return table_concat (t)
end

-- Internal
function self:Normalize ()
	for i = #self, 2, -1 do
		if self [i] ~= 0 then break end
		
		self [i] = nil
	end
end

function self:Truncate (elementCount)
	for i = #self, elementCount + 1, -1 do
		self [i] = nil
	end
end

function self:TruncateAndZero (elementCount)
	for i = 1, elementCount do
		self [i] = 0
	end
	
	self:Truncate (elementCount)
end

return BigInteger
