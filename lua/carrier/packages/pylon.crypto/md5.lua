local self = {}
Crypto.MD5 = Class(self)

local bit_band      = bit.band
local bit_bnot      = bit.bnot
local bit_bor       = bit.bor
local bit_bswap     = bit.bswap
local bit_bxor      = bit.bxor
local bit_rol       = bit.rol
local bit_tobit     = bit.tobit
local math_floor    = math.floor
local string_byte   = string.byte
local string_format = string.format

function Crypto.MD5.Compute(x)
	return Crypto.MD5():Update(x):Finish()
end

function self:ctor()
	self.A, self.B, self.C, self.D = 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476
	
	self.Length = 0
	self.Buffer = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
end

function self:Clone(out)
	local out = out or Crypto.MD5()
	
	out.A, out.B, out.C, out.D = self.A, self.B, self.C, self.D
	
	out.Length = self.Length
	for i = 1, 16 do
		out.Buffer[i] = self.Buffer[i]
	end
	
	return out
end

function self:Reset()
	self.A, self.B, self.C, self.D = 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476
	
	self.Length = 0
	for i = 1, 16 do self.Buffer[i] = 0 end
end

local blockSize = 16
function self:Update(data)
	if #data == 0 then return self end
	
	local dataLength = #data
	local bufferIndex = math_floor(self.Length / 4) % blockSize + 1
	local index = ((4 - self.Length) % 4) + 1
	
	-- Fill in last uint32
	if index == 1 then
	elseif index == 2 then
		local a = string_byte(data, 1)
		self.Buffer[bufferIndex] = self.Buffer[bufferIndex] +
		                            (a or 0) * 0x01000000
		if #data >= 1 then bufferIndex = bufferIndex + 1 end
	elseif index == 3 then
		local a, b = string_byte(data, 1, 2)
		self.Buffer[bufferIndex] = self.Buffer[bufferIndex] +
		                            (a or 0) * 0x00010000 +
		                            (b or 0) * 0x01000000
		if #data >= 2 then bufferIndex = bufferIndex + 1 end
	elseif index == 4 then
		local a, b, c = string_byte(data, 1, 3)
		self.Buffer[bufferIndex] = self.Buffer[bufferIndex] +
		                            (a or 0) * 0x00000100 +
		                            (b or 0) * 0x00010000 +
		                            (c or 0) * 0x01000000
		if #data >= 3 then bufferIndex = bufferIndex + 1 end
	end
	
	-- Fill to end of block
	while #data - index + 1 >= (blockSize - bufferIndex + 1) * 4 do
		for i = bufferIndex, blockSize do
			local a, b, c, d = string_byte(data, index, index + 3)
			self.Buffer[i] = a + b * 0x00000100 + c * 0x00010000 + d * 0x01000000
			index = index + 4
		end
		
		self:Block(self.Buffer)
		bufferIndex = 1
	end
	
	-- Fill remainder
	while index <= #data - 3 do
		local a, b, c, d = string_byte(data, index, index + 3)
		self.Buffer[bufferIndex] = a + b * 0x00000100 + c * 0x00010000 + d * 0x01000000
		bufferIndex = bufferIndex + 1
		index = index + 4
	end
	
	if index <= #data then
		local a, b, c = string_byte(data, index, index + 2)
		self.Buffer[bufferIndex] = a + (b or 0) * 0x00000100 + (c or 0) * 0x00010000
	end
	
	self.Length = self.Length + #data
	return self
end

function self:Finish()
	local bufferIndex = math_floor(self.Length / 4) % blockSize + 1
	local bytesFilled = self.Length % 4
	
	-- Cap with 0x01
	if bytesFilled == 0 then
		self.Buffer[bufferIndex] = 0x00000080
	elseif bytesFilled == 1 then
		self.Buffer[bufferIndex] = self.Buffer[bufferIndex] + 0x00008000
	elseif bytesFilled == 2 then
		self.Buffer[bufferIndex] = self.Buffer[bufferIndex] + 0x00800000
	elseif bytesFilled == 3 then
		self.Buffer[bufferIndex] = self.Buffer[bufferIndex] + 0x80000000
	end
	bufferIndex = bufferIndex + 1
	
	-- Zero fill rest of buffer
	for i = bufferIndex, blockSize do
		self.Buffer[i] = 0
	end
	
	if blockSize - bufferIndex + 1 < 2 then
		self:Block(self.Buffer)
		bufferIndex = 1
		
		for i = 1, blockSize do
			self.Buffer[i] = 0
		end
	end
	
	self.Buffer[blockSize - 1] = (self.Length * 8) % 4294967296
	self.Buffer[blockSize]     = math_floor((self.Length * 8) / 4294967296)
	self:Block(self.Buffer)
	
	return string_format("%08x%08x%08x%08x", bit_bswap(self.A) % 4294967296, bit_bswap(self.B) % 4294967296, bit_bswap(self.C) % 4294967296, bit_bswap(self.D) % 4294967296)
end

-- Internal
local K =
{
	0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
	0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
	0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
	0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
	0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
	0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
	0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
	0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
	0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
	0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
	0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
	0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
	0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
	0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
	0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
	0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391
}
local s =
{
	7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,
	5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,
	4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,
	6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21
}
local g =
{
	1, 2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16,
	2, 7, 12,  1,  6, 11, 16,  5, 10, 15,  4,  9, 14,  3,  8, 13,
	6, 9, 12, 15,  2,  5,  8, 11, 14,  1,  4,  7, 10, 13, 16,  3,
	1, 8, 15,  6, 13,  4, 11,  2,  9, 16,  7, 14,  5, 12,  3, 10
}
function self:Block(block)
	local M = block
	local a, b, c, d = self.A, self.B, self.C, self.D
	for i = 1, 16 do
		local F = bit_bor(bit_band(b, c), bit_band(bit_bnot(b), d))
		F = F + a + K[i] + M[g[i]]
		a, b, c, d = d, b + bit_rol(F, s[i]), b, c
	end
	for i = 17, 32 do
		local F = bit_bor(bit_band(d, b), bit_band(bit_bnot(d), c))
		F = F + a + K[i] + M[g[i]]
		a, b, c, d = d, b + bit_rol(F, s[i]), b, c
	end
	for i = 33, 48 do
		local F = bit_bxor(b, c, d)
		F = F + a + K[i] + M[g[i]]
		a, b, c, d = d, b + bit_rol(F, s[i]), b, c
	end
	for i = 49, 64 do
		local F = bit_bxor(c, bit_bor(b, bit_bnot(d)))
		F = F + a + K[i] + M[g[i]]
		a, b, c, d = d, b + bit_rol(F, s[i]), b, c
	end
	
	self.A, self.B, self.C, self.D = bit_tobit(self.A + a), bit_tobit(self.B + b), bit_tobit(self.C + c), bit_tobit(self.D + d)
end
