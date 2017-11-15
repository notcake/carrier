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
	
	-- Fill in last uint32
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
	
	-- Fill to end of block
	while #data - index + 1 >= (blockSize - bufferIndex + 1) * 4 do
		for i = bufferIndex, blockSize do
			local a, b, c, d = string_byte (data, index, index + 3)
			self.Buffer [i] = a * 0x01000000 + b * 0x00010000 + c * 0x00000100 + d
			index = index + 4
		end
		
		self:Block (self.Buffer)
		bufferIndex = 1
	end
	
	-- Fill remainder
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
	
	-- Cap with 0x01
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
	
	-- Zero fill rest of buffer
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

-- Internal
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
