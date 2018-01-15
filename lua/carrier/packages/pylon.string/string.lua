local string_char   = string.char
local string_format = string.format
local string_gmatch = string.gmatch
local string_gsub   = string.gsub
local table_concat  = table.concat

function String.Split (str, separator)
	local parts = {}
	
	if separator == "" then
		for i = 1, #str do
			parts [#parts + 1] = string.sub (str, i, i)
		end
	end
	
	local startPosition = 1
	while startPosition <= #str do
		local endPosition = string.find (str, separator, startPosition, true)
		if not endPosition then break end
		
		parts [#parts + 1] = string.sub (str, startPosition, endPosition - 1)
		
		startPosition = endPosition + #separator
	end
	
	parts [#parts + 1] = string.sub (str, startPosition)
	
	return parts
end

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

local hexMap = {}
for i = 0, 255 do hexMap [string_char (i)] = string_format ("%02x", i) end
function String.ToHex (str)
	return string_gsub (str, ".", hexMap)
end
