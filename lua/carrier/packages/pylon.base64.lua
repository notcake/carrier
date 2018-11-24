-- PACKAGE Pylon.Base64

local Base64 = {}

local math_floor    = math.floor
local string_byte   = string.byte
local string_char   = string.char
local string_gmatch = string.gmatch
local string_sub    = string.sub
local table_concat  = table.concat

local characterSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

local equals = string_byte("=")
local characterValues = {}
local valueCharacters = {}
for i = 1, #characterSet do
	characterValues[string_byte(characterSet, i)] = i - 1
	valueCharacters[i - 1] = string_byte(characterSet, i)
end
characterValues[string_byte("=")] = 0

function Base64.Decode(s)
	local t = {}
	local a, b, c, d
	for abcd in string_gmatch(s, "[A-Za-z0-9%+/][A-Za-z0-9%+/][A-Za-z0-9%+/=][A-Za-z0-9%+/=]") do
		a, b, c, d = string_byte(abcd, 1, 4)
		local v0, v1, v2, v3 = characterValues[a], characterValues[b], characterValues[c], characterValues[d]
		local c0 =  v0 *  4 + math_floor(v1 * (1 / 16))
		local c1 = (v1 * 16 + math_floor(v2 * (1 /  4))) % 256
		local c2 = (v2 * 64 + v3) % 256
		t[#t + 1] = string_char(c0, c1, c2)
	end
	
	if d == equals then
		t[#t] = string_sub(t[#t], 1, c == equals and 1 or 2)
	end
	
	return table_concat(t)
end

function Base64.Encode(s)
	local t = {}
	
	for i = 3, #s, 3 do
		local c0, c1, c2 = string_byte(s, i - 2, i)
		local v0 = math_floor(c0 * (1 / 4))
		local v1 = (c0 * 16 + math_floor(c1 * (1 / 16))) % 64
		local v2 = (c1 *  4 + math_floor(c2 * (1 / 64))) % 64
		local v3 = c2 % 64
		t[#t + 1] = string_char(valueCharacters[v0], valueCharacters[v1], valueCharacters[v2], valueCharacters[v3])
	end
	
	if #s % 3 == 1 then
		local c0 = string_byte(s, #s)
		local v0 = math_floor(c0 * (1 / 4))
		local v1 = (c0 * 16) % 64
		t[#t + 1] = string_char(valueCharacters[v0], valueCharacters[v1], equals, equals)
	elseif #s % 3 == 2 then
		local c0, c1 = string_byte(s, #s - 1, #s)
		local v0 = math_floor(c0 * (1 / 4))
		local v1 = (c0 * 16 + math_floor(c1 * (1 / 16))) % 64
		local v2 = (c1 * 4) % 64
		t[#t + 1] = string_char(valueCharacters[v0], valueCharacters[v1], valueCharacters[v2], equals)
	end
	
	return table_concat(t)
end

return Base64
