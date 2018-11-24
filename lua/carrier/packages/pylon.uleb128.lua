-- PACKAGE Pylon.ULEB128
ULEB128 = {}

local math_floor = math.floor

function ULEB128.Serialize(n, streamWriter)
	while true do
		if n >= 0x80 then
			local uint8 = n % 0x80
			streamWriter:UInt8(uint8 + 0x80)
			n = math_floor((n - uint8) * (1 / 128))
		else
			streamWriter:UInt8(n)
			break
		end
	end
end

function ULEB128.Deserialize(streamReader)
	local n = 0
	local factor = 1
	
	while true do
		local uint8 = streamReader:UInt8()
		if uint8 >= 0x80 then
			uint8 = uint8 - 0x80
			n = n + uint8 * factor
			factor = factor * 128
		else
			return n + uint8 * factor
		end
	end
end

return ULEB128
