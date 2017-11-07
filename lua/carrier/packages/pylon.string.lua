-- PACKAGE Pylon.String

String = {}

local hexMap = {}
for i = 0, 255 do
	hexMap [string.format ("%02x", i)] = string.char (i)
	hexMap [string.format ("%02X", i)] = string.char (i)
end

function String.FromHex (data)
	local chars = {}
	for hex in string.gmatch (data, "[0-9a-fA-F][0-9a-fA-F]") do
		chars [#chars + 1] = hexMap [hex]
	end
	
	return table.concat (chars)
end

function String.ToHex (str)
	local hex = {}
	for i = 1, #str do
		hex [i] = string.format ("%02X", string.byte (i, i))
	end
	
	return table.concat (hex, " ")
end

return String
