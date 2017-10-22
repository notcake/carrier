local bit = require ("bit")

local bit_band    = bit.band
local bit_bnot    = bit.bnot
local bit_bor     = bit.bor
local bit_bxor    = bit.bxor
local bit_lshift  = bit.lshift
local bit_rshift  = bit.rshift
local string_byte = string.byte

local uint8Cache = {}
for i = 0, 255 do
	local c = i
	local crc = 0
	for j = 1, 8 do
		local a = bit_band (c, 1)
		local b = bit_band (crc, 1)
		
		c   = bit_rshift (c, 1)
		crc = bit_rshift (crc, 1)
		
		if bit_bxor (a, b) == 1 then
			crc = bit_bxor (crc, 0xEDB88320)
		end
	end
	
	uint8Cache [i] = crc
end

local function CRC32 (s)
	local crc = 0xFFFFFFFF
	
	for i = 1, #s do
		local index = bit_bxor (string_byte (s, i), bit_band (crc, 0xFF))
		crc = bit_rshift (crc, 8)
		crc = bit_bxor (crc, uint8Cache[index])
	end
	
	crc = bit_bnot (crc)
	if crc < 0 then crc = crc + 4294967296 end
	return crc
end

return CRC32
