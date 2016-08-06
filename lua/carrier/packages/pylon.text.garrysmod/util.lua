GarrysMod.Util = {}

local string_byte = string.byte
function GarrysMod.Util.IndexOfLastLineBreak (str)
	for i = #str, 1, -1 do
		if string_byte (str, i) == 0x0A then return i end
	end
	
	return nil
end
