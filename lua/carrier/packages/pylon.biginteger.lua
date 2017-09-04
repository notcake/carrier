local OOP    = require ("Pylon.OOP")
local UInt24 = require ("Pylon.UInt24")

local self = {}
local BigInteger = OOP.Class (self)

local tonumber      = tonumber

local bit_band      = bit.band
local bit_rshift    = bit.rshift
local math_floor    = math.floor
local math_log      = math.log
local math_max      = math.max
local string_format = string.format
local string_sub    = string.sub
local table_concat  = table.concat

function BigInteger.FromDecimal (str)
	local n = BigInteger ()
	
	-- Convert to decimal digit array
	local d = {}
	for i = #str, 1, -1 do
		d [#d + 1] = string_sub (str, i, i)
	end
	
	-- Normalize
	for i = #d, 1, -1 do
		if d [i] ~= 0 then break end
		
		d [i] = nil
	end
	
	-- Pull off powers of 2
	local factor = 1
	while #d > 0 do
		if factor > UInt24.Maximum then
			factor = 1
			n [#n + 1] = 0
		end
		
		-- Pull off bit
		if d [1] % 2 == 1 then
			d [1] = d [1] - 1
			n [#n] = n [#n] + factor
		end
		
		-- Divide d by 2
		for i = 1, #d do
			if d [i] % 2 == 1 then
				d [i] = d [i] - 1
				d [i - 1] = d [i - 1] + 5
			end
			d [i] = d [i] / 2
		end
		
		-- Normalize
		if d [#d] == 0 then
			d [#d] = nil
		end
		
		factor = factor * 2
	end
	
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
	local quotient  = out1 or BigInteger ()
	local remainder = self:Clone (out2)
	local a = self
	
	quotient:TruncateAndZero (#a - #b + 1)
	
	for i = #a - #b + 1, 1, -1 do
		-- elementCount of quotient is at most i + 1
	end
	
	return quotient, remainder
end

function self:DivideSmall (b, out)
	local out = out or BigInteger ()
	local a = self
	
	-- Clear
	out:Truncate (#a)
	
	-- Divide
	local remainder = 0
	out [#a], remainder = UInt24.Divide (a [#a], 0, b)
	for i = #a - 1, 1, -1 do
		out [i], remainder = UInt24.Divide (a [i], remainder, b)
	end
	
	-- Normalize
	out:Normalize ()
	
	return out, remainder
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
	t [1] = string_format ("%x", self [#self])
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
