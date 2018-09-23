-- PACKAGE Pylon.BigInteger

local OOP    = require ("Pylon.OOP")
local UInt24 = require ("Pylon.UInt24")

local self = {}
local BigInteger = OOP.Class (self)

-- Two's complement BigInteger.
-- Numbers are stored in little endian form.
-- The last element is the sign element and always 0x0000 or 0xFFFF.
-- There are always 1 or more elements

local bit = require_provider ("bit")

local tonumber      = tonumber

local bit_band      = bit.band
local bit_bnot      = bit.bnot
local bit_bor       = bit.bor
local bit_bxor      = bit.bxor
local bit_lshift    = bit.lshift
local bit_rshift    = bit.rshift
local math_abs      = math.abs
local math_floor    = math.floor
local math_log      = math.log
local math_min      = math.min
local math_max      = math.max
local string_byte   = string.byte
local string_char   = string.char
local string_format = string.format
local string_rep    = string.rep
local string_sub    = string.sub
local table_concat  = table.concat

local UInt24_Zero               = UInt24.Zero
local UInt24_Maximum            = UInt24.Maximum
local UInt24_MostSignificantBit = UInt24.MostSignificantBit
local UInt24_BitCount           = UInt24.BitCount

local UInt24_Add                = UInt24.Add
local UInt24_AddWithCarry       = UInt24.AddWithCarry
local UInt24_Divide             = UInt24.Divide
local UInt24_Multiply           = UInt24.Multiply
local UInt24_MultiplyAdd2       = UInt24.MultiplyAdd2
local UInt24_Subtract           = UInt24.Subtract
local UInt24_SubtractWithBorrow = UInt24.SubtractWithBorrow
local UInt24_CountLeadingZeros  = UInt24.CountLeadingZeros
local UInt24_PopCount           = UInt24.PopCount

local Sign_Negative = UInt24_Maximum
local Sign_Positive = UInt24_Zero

function BigInteger.FromBlob (data)
	local n = BigInteger ()
	
	-- Clear elements
	n [1] = nil
	
	-- Process groups of 3 bytes
	for i = #data - 2, 1, -3 do
		local c0, c1, c2 = string_byte (data, i, i + 2)
		n [#n + 1] = c0 * 0x00010000 + c1 * 0x00000100 + c2
	end
	
	-- Process remaining bytes
	if #data % 3 ~= 0 then
		local c = 0
		for i = 1, #data % 3 do
			c = c * 0x0100
			c = c + string_byte (data, i)
		end
		n [#n + 1] = c
	end
	
	-- Append sign and normalize
	n [#n + 1] = Sign_Positive
	n:Normalize ()
	
	return n
end

function BigInteger.FromDecimal (str)
	local n = BigInteger ()
	
	-- Sign
	local sign     = string_sub (str, 1, 1)
	local negative = string_sub (str, 1, 1) == "-"
	local signLength = (sign == "-" or sign == "+") and 1 or 0
	
	-- Convert to decimal bignum
	local d = {}
	for i = #str - 7, 1 + signLength, -8 do
		d [#d + 1] = tonumber (string_sub (str, i, i + 7))
	end
	
	if (#str - signLength) % 8 ~= 0 then
		d [#d + 1] = tonumber (string_sub (str, 1 + signLength, signLength + (#str - signLength) % 8))
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
	
	-- Append positive sign and normalize
	n [#n + 1] = Sign_Positive
	n:Normalize ()
	
	if negative then
		n = n:Negate (n)
	end
	
	return n
end

function BigInteger.FromHex (str)
	local n = BigInteger ()
	
	n [1] = nil
	
	-- Process groups of 3 bytes
	for i = #str - 5, 1, -6 do
		n [#n + 1] = tonumber (string_sub (str, i, i + 5), 16)
	end
	
	-- Process remaining bytes
	if #str % 6 ~= 0 then
		n [#n + 1] = tonumber (string_sub (str, 1, #str % 6), 16)
	end
	
	-- Append sign and normalize
	n [#n + 1] = Sign_Positive
	n:Normalize ()
	
	return n
end

function BigInteger.FromUInt8 (x)
	return BigInteger.FromInt8 (x)
end

function BigInteger.FromUInt16 (x)
	return BigInteger.FromInt16 (x)
end

function BigInteger.FromUInt32 (x)
	return BigInteger.FromInt32 (x)
end

function BigInteger.FromUInt64 (x)
	return BigInteger.FromInt64 (x)
end

function BigInteger.FromInt8 (x)
	return BigInteger.FromInt16 (x)
end

function BigInteger.FromInt16 (x)
	local n = BigInteger ()
	n [1] = x % 0x01000000
	n [2] = x >= 0 and Sign_Positive or Sign_Negative
	n:Normalize ()
	return n
end

function BigInteger.FromInt32 (x)
	local n = BigInteger ()
	n [1] = x % 0x01000000
	n [2] = math_floor (x / 0x01000000) % 0x01000000
	n [3] = x >= 0 and Sign_Positive or Sign_Negative
	n:Normalize ()
	return n
end

function BigInteger.FromInt64 (x)
	local n = BigInteger ()
	n [1] = x % 0x01000000
	n [2] = math_floor (x / 0x01000000) % 0x01000000
	n [3] = math_floor (x / 0x01000000 / 0x01000000) % 0x01000000
	n [4] = x >= 0 and Sign_Positive or Sign_Negative
	n:Normalize ()
	return n
end

function BigInteger.FromDouble (x)
	local n = BigInteger ()
	
	if x == math.huge or x == -math.huge or x ~= x then
		return n -- 0
	else
		n [1] = nil
		x = math_floor (x)
		while x ~= 0 and x ~= -1 do
			n [#n + 1] = x % 0x01000000
			x = math_floor (x / 0x01000000)
		end
		
		-- Append sign and normalize
		n [#n + 1] = x >= 0 and Sign_Positive or Sign_Negative
		n:Normalize ()
		
		return n
	end
end

function self:ctor ()
	self [1] = Sign_Positive
end

function self:GetBitCount ()
	local leadingBitCount = 1 + math_floor (math_log (self [#self - 1] or 0) / math_log (2))
	leadingBitCount = math_max (0, leadingBitCount)
	local bitCount = math_max (0, #self - 2) * UInt24_BitCount
	return bitCount + leadingBitCount
end

function self:GetPopCount ()
	local popCount = 0
	for i = 1, #self - 1 do
		popCount = popCount + UInt24_PopCount (self [i])
	end
	return popCount
end

function self:IsPositive ()
	return self [#self] == Sign_Positive and #self > 1
end

function self:IsNegative ()
	return self [#self] == Sign_Negative
end

function self:IsZero ()
	return #self == 1 and self [1] == Sign_Positive
end

function self:IsOne ()
	return #self == 2 and self [1] == 1 and self [2] == Sign_Positive
end

-- Comparisons
function self:Compare (b)
	local a = self
	
	-- Check signs
	if a [#a] ~= b [#b] then return a [#a] == Sign_Negative and -1 or 1 end
	
	if #a == #b then
		for i = #a - 1, 1, -1 do
			if a [i] < b [i] then
				return a [#a] == Sign_Positive and -1 or  1
			elseif a [i] > b [i] then
				return a [#a] == Sign_Positive and  1 or -1
			end
		end
		
		return 0
	elseif #a < #b then
		return a [#a] == Sign_Positive and -1 or  1
	else
		return a [#a] == Sign_Positive and  1 or -1
	end
end

function self:Equals (b)
	local a = self
	if #a ~= #b then return false end
	
	for i = 1, #a do
		if a [i] ~= b [i] then return false end
	end
	
	return true
end

function self:IsLessThan           (b) return self:Compare (b) == -1 end
function self:IsLessThanOrEqual    (b) return self:Compare (b) ~=  1 end
function self:IsGreaterThan        (b) return self:Compare (b) ==  1 end
function self:IsGreaterThanOrEqual (b) return self:Compare (b) ~= -1 end

-- Miscellaneous
function self:IsEven () return self [1] % 2 == 0 end
function self:IsOdd  () return self [1] % 2 == 1 end

-- Arithmetic
function self:Negate (b, out)
	-- Flip all bits
	out = self:Not (out)
	
	-- Add 1
	local cf = 1
	for i = 1, #out do
		if cf == 0 then break end
		out [i], cf = UInt24_Add (out [i], cf)
	end
	
	-- The interesting cases are 0 and when the number is
	-- the largest negative number of its size
	--      0000 ->      FFFF -> 1      0000
	-- FFFF 0000 -> 0000 FFFF -> 0 0001 0000
	
	-- Extend positive sign on carry
	if out [#out] == 1 then
		out [#out + 1] = Sign_Positive
	end
	
	return out
end

function self:Add (b, out)
	local out = out or BigInteger ()
	local a = self
	
	-- 0000 0001 + 0000 FFFF = 0 0001 0000 -> 0000 0001 0000
	-- FFFF 0001 +      FFFF = 1 FFFF 0000
	-- FFFF 0001 + FFFF FFFE = 1 FFFE FFFF -> FFFF FFFE FFFF
	-- 0000 0003 + FFFF FFFE = 1 0000 0001
	-- 0000 0001 + FFFF FFFE = 0 FFFF FFFF
	-- 0000 0001 +      FFFF = 0 FFFF 0000
	local cf = 0
	for i = 1, math_min(#a, #b) do
		out [i], cf = UInt24_AddWithCarry (a [i], b [i], cf)
	end
	
	-- Process sign extended part
	local sign = a [#a]
	for i = #a + 1, #b do out [i], cf = UInt24_AddWithCarry (sign, b [i], cf) end
	local sign = b [#b]
	for i = #b + 1, #a do out [i], cf = UInt24_AddWithCarry (a [i], sign, cf) end
	
	-- Clear
	out:Truncate (math_max (#a, #b))
	
	-- Carry
	if out [#out] ~= Sign_Positive and
	   out [#out] ~= Sign_Negative then
		out [#out + 1] = cf == 0 and Sign_Positive or Sign_Negative
	end
	
	-- Normalize
	out:Normalize ()
	
	return out
end

function self:Subtract (b, out)
	local out = out or BigInteger ()
	local a = self
	
	local cf = 0
	for i = 1, math_min (#a, #b) do
		out [i], cf = UInt24_SubtractWithBorrow (a [i], b [i], cf)
	end
	
	-- Process sign extended part
	local sign = a [#a]
	for i = #a + 1, #b do out [i], cf = UInt24_SubtractWithBorrow (sign, b [i], cf) end
	local sign = b [#b]
	for i = #b + 1, #a do out [i], cf = UInt24_SubtractWithBorrow (a [i], sign, cf) end
	
	-- Clear
	out:Truncate (math_max (#a, #b))
	
	-- Carry
	if out [#out] ~= Sign_Positive and
	   out [#out] ~= Sign_Negative then
		out [#out + 1] = cf == 0 and Sign_Negative or Sign_Positive
	end
	
	-- Normalize
	out:Normalize ()
	
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
	out:TruncateAndZero (#a + #b - 1)
	
	-- Multiply
	for i = 1, #a do
		local high = 0
		for j = 1, #b do
			out [i + j - 1], high = UInt24_MultiplyAdd2 (a [i], b [j], out [i + j - 1], high)
		end
		
		-- Carry
		for j = i + #b, #a + #b - 1 do
			if high == 0 then break end
			out [j], high = UInt24_Add (out [j], high)
		end
	end
	
	-- Clear junk
	out:Truncate (math_max (1, #a - 1 + #b - 1))
	
	-- Sign
	out [#out + 1] = (a:IsZero() or b:IsZero()) and Sign_Positive or bit_bxor(a [#a], b [#b])
		
	-- Normalize
	out:Normalize ()
	
	return out
end

function self:Square (out)
	local out = out or BigInteger ()
	local a = self
	
	-- Prepare for convolution
	out:TruncateAndZero (#a * 2 - 1)
	
	-- Multiply
	--    | x0  x1  x2  x3
	-- ---+----------------
	-- x0 | x00 x01 x02 x03
	-- x1 | x10 x11 x12 x13
	-- x2 | x20 x21 x22 x23
	-- x3 | x30 x31 x32 x33
	-- Contributions are symmetric about the diagonal
	for i = 1, #a do
		local high = 0
		for j = 1, i - 1 do
			out [i + j - 1], high = UInt24_MultiplyAdd2 (a [i], a [j], out [i + j - 1], high)
		end
		
		-- Carry
		for j = i * 2 - 1, #a * 2 - 1 do
			if high == 0 then break end
			out [j], high = UInt24_Add (out [j], high)
		end
	end
	
	-- Double
	local carry = 0
	for i = 1, #a * 2 - 1 do
		out [i], carry = UInt24_AddWithCarry (out [i], out [i], carry)
	end
	
	-- Diagonal
	local high = 0
	for i = 1, #a - 1 do
		out [i + i - 1], high = UInt24_MultiplyAdd2 (a [i], a [i], out [i + i - 1], high)
		out [i + i], high = UInt24_Add (out [i + i], high)
	end

	-- Clear junk
	out:Truncate (math_max (1, #a * 2 - 2))
	
	-- Sign
	out [#out + 1] = Sign_Positive
	
	-- Normalize
	out:Normalize ()
	
	return out
end

function self:Divide (b, quotient, remainder)
	if #b <= 2 then
		local quotient, remainder = self:DivideInt24 (b:IsNegative () and -(UInt24_Maximum - b [1] + 1) or b [1], quotient)
		return quotient, BigInteger.FromInt32 (remainder)
	end
	local quotient  = quotient or BigInteger ()
	local remainder = self:IsNegative () and self:Negate (remainder) or self:Clone (remainder)
	local a = self
	
	if b:IsZero () then
		quotient:TruncateAndZero (1)
		return quotient, remainder
	end
	
	local negative = a:IsNegative () ~= b:IsNegative ()
	if a:IsNegative () then a = a:Negate () end
	if b:IsNegative () then b = b:Negate () end
	
	quotient:TruncateAndZero (math_max (1, #a - #b + 2))
	
	-- HACK: Pull in 25 bits of divisor to calculate the quotient
	local additionalBitCount = UInt24_CountLeadingZeros (b [#b - 1]) + 1
	local d = b [#b - 1] * bit_lshift (1, additionalBitCount) + bit_rshift (b [#b - 2], UInt24_BitCount - additionalBitCount)
	
	for i = #a - #b + 1, 1, -1 do
		local r1 = remainder [i + #b - 1] or 0
		local r0 = remainder [i + #b - 2]
		
		-- HACK: Pull in 25 bits of divisor to calculate the quotient
		local r = (r1 * (UInt24_Maximum + 1) + r0) * bit_lshift (1, additionalBitCount) + bit_rshift (remainder [i + #b - 3], UInt24_BitCount - additionalBitCount)
		local q = math_floor (r / d)
		
		local p0, p1 = 0, 0
		local borrow = 0
		for j = 1, #b - 1 do
			p0, p1 = UInt24_MultiplyAdd2 (b [j], q, p1, borrow)
			remainder [i + j - 1], borrow = UInt24_Subtract (remainder [i + j - 1], p0)
		end
		
		remainder [i + #b - 1], borrow = UInt24_SubtractWithBorrow (remainder [i + #b - 1] or 0, p1, borrow)
		
		if borrow > 0 then
			q = q - 1
			
			local carry = 0
			for j = 1, #b - 1 do
				remainder [i + j - 1], carry = UInt24_AddWithCarry (remainder [i + j - 1], b [j], carry)
			end
			remainder [i + #b - 1] = UInt24_Add (remainder [i + #b - 1], carry)
		end
		
		quotient [i] = q
	end
	
	-- Normalize
	quotient:Normalize ()
	remainder:Normalize ()
	
	if negative then
		quotient = quotient:Negate (quotient)
		if not remainder:IsZero () then
			remainder = b:Subtract (remainder)
		end
	end
	
	return quotient, remainder
end

function self:DivideInt24 (b, out)
	local out = out or BigInteger ()
	local a = self
	
	local negative = a:IsNegative () ~= (b < 0)
	local b = math_abs (b)
	
	if a:IsNegative () then
		a = a:Negate ()
	end
	
	-- Clear
	out:Truncate (#a)
	
	-- Divide
	local remainder = 0
	for i = #a, 1, -1 do
		out [i], remainder = UInt24_Divide (a [i], remainder, b)
	end
	
	-- Normalize
	out:Normalize ()
	
	if negative then
		out = out:Negate (out)
		if remainder ~= 0 then
			remainder = b - remainder
		end
	end
	
	return out, remainder
end

function self:Exponentiate (exponent)
	local out = BigInteger.FromUInt32 (1)
	local temp = BigInteger ()
	
	-- Avoid computing factors all the way to self ^ (2 ^ UInt24.BitCount)
	local exponentBitCount = exponent:GetBitCount ()
	
	local factor = self:Clone ()
	for i = 1, #exponent - 1 do
		local mask = 1
		for j = 1, math.min (UInt24_BitCount, exponentBitCount - (i - 1) * UInt24_BitCount) do
			if bit_band (exponent [i], mask) ~= 0 then
				out, temp = out:Multiply (factor, temp), out
			end
			
			mask = mask * 2
			factor, temp = factor:Square (temp), factor
		end
	end
	
	return out
end

function self:ExponentiateMod (exponent, m)
	if m:IsOdd () and #exponent >= 4 then return self:MontgomeryExponentiateMod (exponent, m) end
	
	local out = BigInteger.FromUInt32 (1)
	local product  = BigInteger ()
	local quotient = BigInteger ()
	
	local factor = self:Clone ()
	for i = 1, #exponent - 1 do
		local mask = 1
		for j = 1, UInt24_BitCount do
			if bit_band (exponent [i], mask) ~= 0 then
				product = out:Multiply (factor, product)
				out = product:Mod (m, out, quotient)
			end
			
			mask = mask * 2
			product = factor:Square (product)
			factor = product:Mod (m, factor, quotient)
		end
	end
	
	return out
end

function self:Mod (b, remainder, quotient)
	local quotient, remainder = self:Divide (b, quotient, remainder)
	return remainder, quotient
end

-- Bitwise operations
function self:And (b, out)
	local out = out or BigInteger ()
	local a = self
	
	-- Normalize so that a is longer than b
	if #a < #b then a, b = b, a end
	
	-- Shared elements
	for i = 1, #b do
		out [i] = bit_band (a [i], b [i])
	end
	
	if b:IsNegative () then
		-- Tail of 1s, copy a across
		for i = #b + 1, #a do
			out [i] = a [i]
		end
		out:Truncate (#a)
	else
		-- Tail of 0s, no more non-zero bits
		out:Truncate (#b)
		out:Normalize ()
	end
	
	return out
end

function self:Or (b, out)
	local out = out or BigInteger ()
	local a = self
	
	-- Normalize so that a is longer than b
	if #a < #b then a, b = b, a end
	
	-- Shared elements
	for i = 1, #b do
		out [i] = bit_bor (a [i], b [i])
	end
	
	if b:IsNegative () then
		-- Tail of 1s, no more non-one bits
		out:Truncate (#b)
		out:Normalize ()
	else
		-- Tail of 0s, copy a across
		for i = #b + 1, #a do
			out [i] = a [i]
		end
		out:Truncate (#a)
	end
	
	return out
end

function self:Xor (b, out)
	local out = out or BigInteger ()
	local a = self
	
	-- Normalize so that a is longer than b
	if #a < #b then a, b = b, a end
	
	-- Shared elements
	for i = 1, #b do
		out [i] = bit_bxor (a [i], b [i])
	end
	
	if b:IsNegative () then
		-- Tail of 1s, copy inverted a across
		for i = #b + 1, #a do
			out [i] = bit_bxor (a [i], UInt24_Maximum)
		end
		out:Truncate (#a)
	else
		-- Tail of 0s, copy a across
		for i = #b + 1, #a do
			out [i] = a [i]
		end
		out:Truncate (#a)
	end
	
	return out
end

function self:Not (out)
	local out = out or BigInteger ()
	
	for i = 1, #self do
		out [i] = bit_bxor (self [i], UInt24_Maximum)
	end
	
	out:Truncate (#self)
	
	return out
end

function self:ShiftLeft (n, out)
	local out = out or BigInteger ()
	
	local elementCount = math_floor (n / UInt24_BitCount)
	local k1 = bit_lshift (1, n % UInt24_BitCount)
	local k2 = 1 / bit_lshift (1, UInt24_BitCount - n % UInt24_BitCount)
	local mod = UInt24_Maximum + 1
	
	local n = #self
	local sign = self [n]
	out:Truncate (n + elementCount + 1)
	out [n + elementCount + 1] = (sign * k1 + math_floor (self [n] * k2)) % mod
	for i = n + elementCount, elementCount + 2, -1 do
		out [i] = (self [i - elementCount] * k1 + math_floor (self [i - elementCount - 1] * k2)) % mod
	end
	out [elementCount + 1] = self [1] * k1 % mod
	for i = elementCount, 1, -1 do
		out [i] = 0
	end
	
	out:Normalize ()
	
	return out
end

function self:ShiftRight (n, out)
	local out = out or BigInteger ()
	
	local elementCount = math_floor (n / UInt24_BitCount)
	local k1 = bit_lshift (1, UInt24_BitCount - n % UInt24_BitCount)
	local k2 = 1 / bit_lshift (1, n % UInt24_BitCount)
	local mod = UInt24_Maximum + 1
	
	for i = 1, #self - elementCount - 1 do
		out [i] = (self [i + elementCount + 1] * k1 + math_floor (self [i + elementCount] * k2)) % mod
	end
	out [math_max (0, #self - elementCount)] = self [#self]
	
	out:Truncate (math_max (1, #self - elementCount))
	out:Normalize ()
	
	return out
end

-- Miscellaneous
function self:GCD (b)
	local a = self
	
	while not b:IsZero () do
		a, b = b, a:Mod (b)
	end
	
	return a
end

function self:ModularInverse (m)
	local a, b = m, self
	local previousR, r = a:Clone (), b:Clone ()
	local previousT, t = BigInteger (), BigInteger.FromDouble (1)
	local temp = BigInteger ()
	local q = BigInteger ()
	
	-- a s_0 + b t_0 = r_0 = a => s_0 = 1, t_0 = 0
	-- a s_1 + b t_1 = r_1 = b => s_1 = 0, t_1 = 1
	
	-- r_i+1 = r_i-1 - r_i q_i
	--       = (a s_i-1 + b t_i-1) - (a s_i + b t_i) q_i
	--       = (a s_i-1 - a s_i q_i) + (b t_i-1 - b t_i q_i)
	--       = a (s_i-1 - s_i q_i) + b (t_i-1 - t_i q_i)
	while not r:IsZero () do
		q, temp = previousR:Divide (r, q, temp)
		previousR, r, temp = r, temp, previousR
		
		-- s_i+1 = s_i-1 - s_i q_i
		-- t_i+1 = t_i-1 - t_i q_i
		temp = t:Multiply (q, temp)
		temp, q = previousT:Subtract (temp, q), temp
		previousT, t, temp = t, temp, previousT
	end
	
	-- r_i = gcd(self, m)
	-- r_i+1 == 0
	
	-- gcd must be 1 for there to be an inverse
	if previousR:IsPositive () and (#previousR > 2 or previousR [1] > 1) then return nil end
	
	-- Return normalized inverse
	return previousT:IsNegative () and previousT:Add (m, temp) or previousT
end

function self:Root (n)
	if self:IsNegative () then return false, nil end
	if not n:IsPositive () then return false, nil end
	if self:IsZero () then return true, self end
	if self:Equals (BigInteger.FromDouble (1)) then return true, self end
	if n:Equals (BigInteger.FromDouble (1)) then return true, self end
	
	local one = BigInteger.FromDouble (1)
	local two = BigInteger.FromDouble (2)
	
	-- lowerBound inclusive, upperBound inclusive
	local temp1 = BigInteger ()
	local temp2 = BigInteger ()
	local lowerBound = one:Clone ()
	local upperBound = one:ShiftLeft (BigInteger.FromDouble (self:GetBitCount ()) / n + 1)
	local mid = BigInteger ()
	while not lowerBound:Equals (upperBound) do
		temp1 = lowerBound:Add (upperBound, temp1)
		temp1 = temp1:Add (one, temp1)
		mid = temp1:Divide (two, mid, temp2)
		
		temp1 = mid:Exponentiate (n, temp1)
		local cmp = temp1:Compare (self)
		if cmp == 0 then
			return true, mid
		elseif cmp == 1 then
			upperBound = mid:Subtract (one)
		elseif cmp == -1 then
			lowerBound = mid:Clone (lowerBound)
		end
	end
	
	temp1 = lowerBound:Exponentiate (n, temp1)
	return temp1:Equals (self), lowerBound
end

-- Conversions
function self:ToBlob ()
	local t = {}
	
	-- Format start
	local x = self [#self - 1] or self [#self]
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
	for i = #self - 2, 1, -1 do
		local x = self [i]
		local c0 = bit_rshift (x, 16)
		local c1 = bit_band (bit_rshift (x, 8), 0xFF)
		local c2 = bit_band (x, 0xFF)
		
		t [#t + 1] = string_char (c0, c1, c2)
	end
	
	return table_concat (t)
end

function self:ToDecimal ()
	local negative = self:IsNegative ()
	local n = negative and self:Negate () or self:Clone ()
	
	-- Strip off digits in groups of 7
	local t = {}
	repeat
		n, t [#t + 1] = n:DivideInt24 (10000000, n)
	until n:IsZero ()
	
	-- Reverse
	for i = 1, #t / 2 do
		t [i], t [#t - i + 1] = t [#t - i + 1], t [i]
	end
	
	-- Format
	t [1] = (negative and "-" or "") .. tonumber (t [1])
	for i = 2, #t do
		t [i] = string_format ("%07d", t [i])
	end
	
	return table_concat (t)
end

function self:ToHex (digitCount)
	if #self == 1 then
		return string_rep (self [#self] == UInt24_Zero and "0" or "f", digitCount or 2)
	end
	
	local t = {}
	
	-- Format start
	local leadingDigitCount = digitCount and math_max (0, digitCount - 6 * (#self - 2)) or nil
	if leadingDigitCount then
		if leadingDigitCount > 6 then
			t [#t + 1] = string_rep (self:IsNegative () and "f" or "0", leadingDigitCount - 6)
			leadingDigitCount = 6
		end
		t [#t + 1] = string_format ("%0" .. leadingDigitCount .. "x", self [#self - 1])
	else
		-- Ensure an even number of digits
		local s = string_format ("%x", self [#self - 1])
		if #s % 2 == 1 then
			t [#t + 1] = self:IsNegative () and "f" or "0"
		end
		
		t [#t + 1] = s
	end
	
	-- Format rest
	for i = #self - 2, 1, -1 do
		t [#t + 1] = string_format ("%06x", self [i])
	end
	
	return table_concat (t)
end

function self:ToUInt32 ()
	return self [1] + bit_lshift (bit_band (self [2] or 0, 0xFF), UInt24_BitCount)
end

-- Internal
function self:Normalize ()
	local sign = self [#self]
	for i = #self - 1, 1, -1 do
		if self [i] ~= sign then break end
		
		self [i + 1] = nil
	end
end

function self:Truncate (elementCount)
	for i = #self, elementCount + 1, -1 do
		self [i] = nil
	end
end

local BigInteger_Truncate = self.Truncate
function self:TruncateAndZero (elementCount)
	for i = 1, elementCount do
		self [i] = 0
	end
	
	BigInteger_Truncate (self, elementCount)
end

function self:MontgomeryReduce (m2, m, out, temp)
	out = out or BigInteger ()
	
	-- Prepare for multiplication
	out:TruncateAndZero (#m + #m - 1)
	for i = 1, #self do out [i] = self [i] end
	
	-- Multiply add
	for i = 1, #m - 1 do
		local u = UInt24_Multiply (out [i], m2 [1])
		
		local high = 0
		for j = 1, #m - 1 do
			out [i + j - 1], high = UInt24_MultiplyAdd2 (u, m [j], high, out [i + j - 1])
		end
		
		-- Carry
		for j = i + #m - 1, #m + #m - 1 do
			if high == 0 then break end
			out [j], high = UInt24_Add (out [j], high)
		end
	end
	
	-- Divide by r / shift right
	local shift = #m - 1
	for i = 1, #out - shift do
		out [i] = out [i + shift]
	end
	for i = #out, #out - shift + 1, -1 do
		out [i] = nil
	end
	
	-- Normalize
	out:Normalize ()
	
	-- Normalize
	if out:IsGreaterThanOrEqual (m) then
		return out:Subtract (m, temp), out
	else
		return out, temp
	end
end

function self:MontgomeryExponentiateMod (exponent, m)
	-- temp1 = base
	-- temp2 = r
	local temp1 = BigInteger.FromDouble (0x01000000)
	local temp2 = BigInteger ()
	for i = 1, #m - 1 do
		temp2 [i] = 0
	end
	temp2 [#m] = 0x00000001
	temp2 [#m + 1] = Sign_Positive
	
	-- m′ = -m^-1 mod base
	local m2 = m:ModularInverse (temp1)
	m2 [1] = -m2 [1] + 0x01000000
	
	-- out    = R mod m
	-- factor = aR mod m
	local out = temp2:Mod (m, BigInteger (), temp1)
	local factor = self:Multiply (out, temp1):Mod (m, BigInteger (), temp2)
	for i = 1, #exponent - 1 do
		local mask = 1
		for j = 1, UInt24_BitCount do
			if bit_band (exponent [i], mask) ~= 0 then
				temp1 = out:Multiply (factor, temp1)
				out, temp2 = temp1:MontgomeryReduce (m2, m, out, temp2)
			end
			
			mask = mask * 2
			temp1 = factor:Square (temp1)
			factor, temp2 = temp1:MontgomeryReduce (m2, m, factor, temp2)
		end
	end
	
	return out:MontgomeryReduce (m2, m, temp1, temp2)
end

function self:__unm ()
	return self:Negate ()
end

function self:__add (b)
	if type (b) == "number" then b = BigInteger.FromDouble (b) end
	return self:Add (b)
end

function self:__sub (b)
	if type (b) == "number" then b = BigInteger.FromDouble (b) end
	return self:Subtract (b)
end

function self:__mul (b)
	if type (b) == "number" then b = BigInteger.FromDouble (b) end
	return self:Multiply (b)
end

function self:__div (b)
	if type (b) == "number" then b = BigInteger.FromDouble (b) end
	return self:Divide (b)
end

function self:__mod (b)
	if type (b) == "number" then b = BigInteger.FromDouble (b) end
	return self:Mod (b)
end

function self:__pow (b)
	if type (b) == "number" then b = BigInteger.FromDouble (b) end
	return self:Exponentiate (b)
end

function self:__eq (b)
	if type (b) == "number" then b = BigInteger.FromDouble (b) end
	return self:Equals (b)
end

function self:__lt (b)
	if type (b) == "number" then b = BigInteger.FromDouble (b) end
	return self:IsLessThan (b)
end

function self:__le (b)
	if type (b) == "number" then b = BigInteger.FromDouble (b) end
	return self:IsLessThanOrEqual (b)
end

function self:__tostring ()
	return self:ToDecimal ()
end

return BigInteger
