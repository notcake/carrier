-- Hand-crafted code preloader, computer-generated with ❤

-- Artisanal prime numbers, do not steal
local publicKeyExponent = "37"
local publicKeyModulus  = "106056291570996536362892972458134386607944782646099476666004477398593021381265168519157602497596187892341773441098277259949408972323403762038843216196639345409594712291737866476420257402419480038045274295817765270853537753647528438385606853544552381206455876037206479923973761406254483085757596727456629819421"

local OOP = {}
function OOP.Class (methodTable)
	return function (...)
		local object = {}
		setmetatable (object,
			{
				__index = methodTable,
				__call  = methodTable.__call
			}
		)
		
		object:ctor (...)
		
		return object
	end
end
local function Class (methodTable)
	return setmetatable ({}, { __call = OOP.Class (methodTable) })
end

-- TODO: better crypto
local Crypto = {}
local self = {}
Crypto.SHA256 = Class (self)

local bit_band      = bit.band
local bit_bnot      = bit.bnot
local bit_bxor      = bit.bxor
local bit_lshift    = bit.lshift
local bit_ror       = bit.ror
local bit_rshift    = bit.rshift
local bit_tobit     = bit.tobit
local math_floor    = math.floor
local string_byte   = string.byte
local string_format = string.format

function Crypto.SHA256.Compute (x)
	return Crypto.SHA256 ():Update (x):Finish ()
end

function self:ctor ()
	self.State = { 0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19 }
	
	self.Length = 0
	self.Buffer = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
end

local blockSize = 16
function self:Update (data)
	if #data == 0 then return self end
	
	local dataLength = #data
	local bufferIndex = math_floor (self.Length / 4) % blockSize + 1
	local index = ((4 - self.Length) % 4) + 1
	if index == 1 then
	elseif index == 2 then
		local a = string_byte (data, 1)
		self.Buffer [bufferIndex] = self.Buffer [bufferIndex] +
		                             (a or 0) * 0x00000001
		if #data >= 1 then bufferIndex = bufferIndex + 1 end
	elseif index == 3 then
		local a, b = string_byte (data, 1, 2)
		self.Buffer [bufferIndex] = self.Buffer [bufferIndex] +
		                             (a or 0) * 0x00000100 +
		                             (b or 0) * 0x00000001
		if #data >= 2 then bufferIndex = bufferIndex + 1 end
	elseif index == 4 then
		local a, b, c = string_byte (data, 1, 3)
		self.Buffer [bufferIndex] = self.Buffer [bufferIndex] +
		                             (a or 0) * 0x00010000 +
		                             (b or 0) * 0x00000100 +
		                             (c or 0) * 0x00000001
		if #data >= 3 then bufferIndex = bufferIndex + 1 end
	end
	while #data - index + 1 >= (blockSize - bufferIndex + 1) * 4 do
		for i = bufferIndex, blockSize do
			local a, b, c, d = string_byte (data, index, index + 3)
			self.Buffer [i] = a * 0x01000000 + b * 0x00010000 + c * 0x00000100 + d
			index = index + 4
		end
		
		self:Block (self.Buffer)
		bufferIndex = 1
	end
	while index <= #data - 3 do
		local a, b, c, d = string_byte (data, index, index + 3)
		self.Buffer [bufferIndex] = a * 0x01000000 + b * 0x00010000 + c * 0x00000100 + d
		bufferIndex = bufferIndex + 1
		index = index + 4
	end
	
	if index <= #data then
		local a, b, c = string_byte (data, index, index + 2)
		self.Buffer [bufferIndex] = a * 0x01000000 + (b or 0) * 0x00010000 + (c or 0) * 0x00000100
	end
	
	self.Length = self.Length + #data
	return self
end

function self:Finish ()
	local bufferIndex = math_floor (self.Length / 4) % blockSize + 1
	local bytesFilled = self.Length % 4
	if bytesFilled == 0 then
		self.Buffer [bufferIndex] = 0x80000000
	elseif bytesFilled == 1 then
		self.Buffer [bufferIndex] = self.Buffer [bufferIndex] + 0x00800000
	elseif bytesFilled == 2 then
		self.Buffer [bufferIndex] = self.Buffer [bufferIndex] + 0x00008000
	elseif bytesFilled == 3 then
		self.Buffer [bufferIndex] = self.Buffer [bufferIndex] + 0x00000080
	end
	bufferIndex = bufferIndex + 1
	for i = bufferIndex, blockSize do
		self.Buffer [i] = 0
	end
	
	if blockSize - bufferIndex + 1 < 2 then
		self:Block (self.Buffer)
		bufferIndex = 1
		
		for i = 1, blockSize do
			self.Buffer [i] = 0
		end
	end
	
	self.Buffer [blockSize - 1] = math_floor ((self.Length * 8) / 4294967296)
	self.Buffer [blockSize]     = (self.Length * 8) % 4294967296
	self:Block (self.Buffer)
	
	return string_format ("%08x%08x%08x%08x%08x%08x%08x%08x", self.State [1] % 4294967296, self.State [2] % 4294967296, self.State [3] % 4294967296, self.State [4] % 4294967296, self.State [5] % 4294967296, self.State [6] % 4294967296, self.State [7] % 4294967296, self.State [8] % 4294967296)
end
local K =
{
	0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
	0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
	0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
	0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
	0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
	0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
	0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
	0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
}
local w = {}
function self:Block (block)
	for i = 1, blockSize do
		w [i] = block [i]
	end
	
	for i = 17, 64 do
		local s0 = bit_bxor (bit_ror (w [i - 15],  7), bit_ror (w [i - 15], 18), bit_rshift (w [i - 15],  3))
		local s1 = bit_bxor (bit_ror (w [i -  2], 17), bit_ror (w [i -  2], 19), bit_rshift (w [i -  2], 10))
		w [i] = w [i - 16] + s0 + w [i - 7] + s1
	end
	
	local h0, h1, h2, h3, h4, h5, h6, h7 = self.State [1], self.State [2], self.State [3], self.State [4], self.State [5], self.State [6], self.State [7], self.State [8]
	
	for i = 1, 64 do
		local S1 = bit_bxor (bit_ror (h4, 6), bit_ror (h4, 11), bit_ror (h4, 25))
		local ch = bit_bxor (bit_band (h4, h5), bit_band (bit_bnot (h4), h6))
		local temp1 = bit_tobit (h7 + S1 + ch + bit_tobit (K [i] + w [i]))
		local S0 = bit_bxor (bit_ror (h0, 2), bit_ror (h0, 13), bit_ror (h0, 22))
		local maj = bit_bxor (bit_band (h0, h1), bit_band (h0, h2), bit_band (h1, h2))
		local temp2 = S0 + maj
		
		h7 = h6
		h6 = h5
		h5 = h4
		h4 = h3 + temp1
		h3 = h2
		h2 = h1
		h1 = h0
		h0 = temp1 + temp2
	end
	
	self.State [1], self.State [2], self.State [3], self.State [4], self.State [5], self.State [6], self.State [7], self.State [8] = self.State [1] + h0, self.State [2] + h1, self.State [3] + h2, self.State [4] + h3, self.State [5] + h4, self.State [6] + h5, self.State [7] + h6, self.State [8] + h7
end


local Base64 = {}
local math_floor    = math.floor
local string_byte   = string.byte
local string_char   = string.char
local string_gmatch = string.gmatch
local string_sub    = string.sub
local table_concat  = table.concat

local characterSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

local equals = string_byte ("=")
local characterValues = {}
local valueCharacters = {}
for i = 1, #characterSet do
	characterValues [string_byte (characterSet, i)] = i - 1
	valueCharacters [i - 1] = string_byte (characterSet, i)
end
characterValues [string_byte ("=")] = 0

function Base64.Decode (s)
	local t = {}
	local a, b, c, d
	for abcd in string_gmatch (s, "[A-Za-z0-9%+/][A-Za-z0-9%+/][A-Za-z0-9%+/=][A-Za-z0-9%+/=]") do
		a, b, c, d = string_byte (abcd, 1, 4)
		local v0, v1, v2, v3 = characterValues [a], characterValues [b], characterValues [c], characterValues [d]
		local c0 =  v0 *  4 + math_floor (v1 * (1 / 16))
		local c1 = (v1 * 16 + math_floor (v2 * (1 /  4))) % 256
		local c2 = (v2 * 64 + v3) % 256
		t [#t + 1] = string_char (c0, c1, c2)
	end
	
	if d == equals then
		t [#t] = string_sub (t [#t], 1, c == equals and 1 or 2)
	end
	
	return table_concat (t)
end

local String = {}
local string_char   = string.char
local string_gmatch = string.gmatch
local table_concat  = table.concat
local hexMap = {}
for i = 0, 255 do
	hexMap [string_format ("%02x", i)] = string_char (i)
	hexMap [string_format ("%02X", i)] = string_char (i)
end
function String.FromHex (data)
	local chars = {}
	for hex in string_gmatch (data, "[0-9a-fA-F][0-9a-fA-F]") do
		chars [#chars + 1] = hexMap [hex]
	end
	
	return table_concat (chars)
end

local UInt24 = {}
local bit_band   = bit.band
local math_floor = math.floor
local math_log   = math.log
local math_max   = math.max
UInt24.Zero               = 0x00000000
UInt24.Maximum            = 0x00FFFFFF
UInt24.BitCount           = 24
function UInt24.Add (a, b)
	local c = a + b
	return bit_band (c, 0x00FFFFFF), math_floor (c / 0x01000000)
end
function UInt24.AddWithCarry (a, b, cf)
	local c = a + b + cf
	return bit_band (c, 0x00FFFFFF), math_floor (c / 0x01000000)
end
function UInt24.MultiplyAdd2 (a, b, c, d)
	local c = a * b + c + d
	return bit_band (c, 0x00FFFFFF), math_floor (c / 0x01000000)
end
function UInt24.Subtract (a, b)
	local c = a - b
	return bit_band (c, 0x00FFFFFF), -math_floor (c / 0x01000000)
end
function UInt24.SubtractWithBorrow (a, b, cf)
	local c = a - b - cf
	return bit_band (c, 0x00FFFFFF), -math_floor (c / 0x01000000)
end
local k = math_log (2)
function UInt24.CountLeadingZeros (x)
	return 24 - math_max (0, math_floor (1 + math_log(x) / k))
end

local self = {}
local BigInteger = Class (self)
local tonumber      = tonumber
local bit_band      = bit.band
local bit_rshift    = bit.rshift
local math_floor    = math.floor
local math_max      = math.max
local string_byte   = string.byte
local string_sub    = string.sub
local table_concat  = table.concat
local UInt24_Zero               = UInt24.Zero
local UInt24_Maximum            = UInt24.Maximum
local UInt24_BitCount           = UInt24.BitCount
local UInt24_Add                = UInt24.Add
local UInt24_AddWithCarry       = UInt24.AddWithCarry
local UInt24_MultiplyAdd2       = UInt24.MultiplyAdd2
local UInt24_Subtract           = UInt24.Subtract
local UInt24_SubtractWithBorrow = UInt24.SubtractWithBorrow
local UInt24_CountLeadingZeros  = UInt24.CountLeadingZeros
local Sign_Negative = UInt24_Maximum
local Sign_Positive = UInt24_Zero
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
	n [#n + 1] = Sign_Positive
	n:Normalize ()
	
	return n
end
function BigInteger.FromDecimal (str)
	local n = BigInteger ()
	local sign     = string_sub (str, 1, 1)
	local negative = string_sub (str, 1, 1) == "-"
	local signLength = (sign == "-" or sign == "+") and 1 or 0
	local d = {}
	for i = #str - 7, 1 + signLength, -8 do
		d [#d + 1] = tonumber (string_sub (str, i, i + 7))
	end
	
	if (#str - signLength) % 8 ~= 0 then
		d [#d + 1] = tonumber (string_sub (str, 1 + signLength, signLength + (#str - signLength) % 8))
	end
	for i = #d, 1, -1 do
		if d [i] ~= 0 then break end
		
		d [i] = nil
	end
	n [1] = nil
	repeat
		local remainder = 0
		for i = #d, 1, -1 do
			local a = d [i] + remainder * 100000000
			d [i], remainder = math_floor (a / 0x01000000), bit_band (a, 0x00FFFFFF)
		end
		
		n [#n + 1] = remainder
		if d [#d] == 0 then
			d [#d] = nil
		end
	until #d == 0
	n [#n + 1] = Sign_Positive
	n:Normalize ()
	
	if negative then
		n = n:Negate (n)
	end
	
	return n
end
function BigInteger.FromUInt32 (x)
	return BigInteger.FromInt32 (x)
end
function BigInteger.FromInt32 (x)
	local n = BigInteger ()
	n [1] = x % 0x01000000
	n [2] = math_floor (x / 0x01000000) % 0x01000000
	n [3] = x >= 0 and Sign_Positive or Sign_Negative
	n:Normalize ()
	return n
end
function self:ctor ()
	self [1] = Sign_Positive
end
function self:Clone (out)
	local out = out or BigInteger ()
	
	for i = 1, #self do
		out [i] = self [i]
	end
	
	out:Truncate (#self)
	
	return out
end
function self:IsZero ()
	return #self == 1 and self [1] == Sign_Positive
end
function self:IsNegative ()
	return self [#self] == Sign_Negative
end
function self:IsOdd  () return self [1] % 2 == 1 end
function self:Multiply (b, out)
	local out = out or BigInteger ()
	local a = self
	out:TruncateAndZero (#a + #b - 1)
	for i = 1, #a do
		local high = 0
		for j = 1, #b do
			out [i + j - 1], high = UInt24_MultiplyAdd2 (a [i], b [j], out [i + j - 1], high)
		end
		for j = i + #b, #a + #b - 1 do
			if high == 0 then break end
			out [j], high = UInt24_Add (out [j], high)
		end
	end
	out:Truncate (math_max (1, #a - 1 + #b - 1))
	out [#out + 1] = (a:IsZero() or b:IsZero()) and Sign_Positive or bit_bxor(a [#a], b [#b])
	out:Normalize ()
	
	return out
end
function self:Square (out)
	local out = out or BigInteger ()
	local a = self
	out:TruncateAndZero (#a * 2 - 1)
	for i = 1, #a do
		local high = 0
		for j = 1, i - 1 do
			out [i + j - 1], high = UInt24_MultiplyAdd2 (a [i], a [j], out [i + j - 1], high)
		end
		for j = i * 2 - 1, #a * 2 - 1 do
			if high == 0 then break end
			out [j], high = UInt24_Add (out [j], high)
		end
	end
	local carry = 0
	for i = 1, #a * 2 - 1 do
		out [i], carry = UInt24_AddWithCarry (out [i], out [i], carry)
	end
	local high = 0
	for i = 1, #a - 1 do
		out [i + i - 1], high = UInt24_MultiplyAdd2 (a [i], a [i], out [i + i - 1], high)
		out [i + i], high = UInt24_Add (out [i + i], high)
	end
	out:Truncate (math_max (1, #a * 2 - 2))
	out [#out + 1] = Sign_Positive
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
	local additionalBitCount = UInt24_CountLeadingZeros (b [#b - 1]) + 1
	local d = b [#b - 1] * bit_lshift (1, additionalBitCount) + bit_rshift (b [#b - 2], UInt24_BitCount - additionalBitCount)
	
	for i = #a - #b + 1, 1, -1 do
		local r1 = remainder [i + #b - 1] or 0
		local r0 = remainder [i + #b - 2]
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
	quotient:Normalize ()
	remainder:Normalize ()
	
	if negative then
		quotient = quotient:Negate (quotient)
	end
	
	return quotient, remainder
end
function self:Mod (b, remainder, quotient)
	local quotient, remainder = self:Divide (b, quotient, remainder)
	return remainder, quotient
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
function self:ToBlob ()
	local t = {}
	local x = self [#self - 1]
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
	for i = #self - 2, 1, -1 do
		local x = self [i]
		local c0 = bit_rshift (x, 16)
		local c1 = bit_band (bit_rshift (x, 8), 0xFF)
		local c2 = bit_band (x, 0xFF)
		
		t [#t + 1] = string_char (c0, c1, c2)
	end
	
	return table_concat (t)
end

local publicKeyExponent = BigInteger.FromDecimal (publicKeyExponent)
local publicKeyModulus  = BigInteger.FromDecimal (publicKeyModulus)

local function Log (message)
	print ("Carrier: " .. message)
end

local warningColor = Color (255, 192, 64)
local function Warning (message)
	MsgC (warningColor, "Carrier: " .. message .. "\n")
end

local function Reset ()
	file.Delete ("garrysmod.io/carrier/bootstrap.dat")
	file.Delete ("garrysmod.io/carrier/bootstrap.signature.dat")
	Warning ("Flushed cached bootstrap code.")
end

local function GetValidatedCode ()
	local package   = file.Read ("garrysmod.io/carrier/bootstrap.dat", "DATA")
	local signature = file.Read ("garrysmod.io/carrier/bootstrap.signature.dat", "DATA")
	if not package or not signature then return nil, nil end
	
	local sha256a = string.sub (BigInteger.FromBlob(signature):ExponentiateMod (publicKeyExponent, publicKeyModulus):ToBlob (), -32, -1)
	local sha256b = String.FromHex (Crypto.SHA256.Compute (package))
	if sha256a == sha256b then
		return string.match (package, "%-%- BEGIN CARRIER BOOTSTRAP.-%-%- END CARRIER BOOTSTRAP\r?\n"), package
	else
		Warning ("Invalid bootstrap code signature!")
		Reset ()
		return nil, nil
	end
end

local function Fetch (url, f, n)
	local n = n or 1
	http.Fetch (url,
		function (data)
			Log ("Fetched " .. url .. ".")
			f (true, data)
		end,
		function (err)
			if n == 10 then f (false) return end
			
			local delay = 1 * math.pow (2, n - 1)
			Warning ("Failed to fetch from " .. url .. ", retrying in " .. delay .. " second(s)...")
			timer.Simple (delay, function () Fetch (url, f, n + 1) end)
		end
	)
end

local function WithBootstrap (f)
	local code, package = GetValidatedCode ()
	if code then f (code, package) return end
	
	Fetch ("https://garrysmod.io/api/packages/v1/bootstrap",
		function (success, data)
			if not success then
				Warning ("Failed to fetch bootstrap code, aborting!")
				return
			end
			
			local data = util.JSONToTable (data)
			if not data then
				Warning ("Bad response (" .. string.gsub (string.sub (data, 1, 128), "[\r\n]+", " ") .. ")")
				return
			end
			file.Write ("garrysmod.io/carrier/bootstrap.dat",           Base64.Decode (data.package))
			file.Write ("garrysmod.io/carrier/bootstrap.signature.dat", Base64.Decode (data.signature))
			
			local code, package = GetValidatedCode ()
			if code then f (code, package) end
		end
	)
end

WithBootstrap (
	function (code, package)
		local f = CompileString (code, "carrier.bootstrap.lua", false)
		if type (f) == "string" then
			Warning (f)
		else
			local success, err = xpcall (f, debug.traceback)
			if not success then
				Warning (err)
			end
			
			if not Carrier then
				Reset ()
			end
		end
	end
)
