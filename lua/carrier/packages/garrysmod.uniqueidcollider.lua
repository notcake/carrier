-- PACKAGE GarrysMod.UniqueIdCollider

local CRC32 = require("Pylon.CRC32")
local Cat   = require("Cat")

local formats = { "STEAM_0:0:0", "STEAM_0:0:00", "STEAM_0:0:000", "STEAM_0:0:0000", "STEAM_0:0:00000", "STEAM_0:0:000000", "STEAM_0:0:0000000", "STEAM_0:0:00000000", "STEAM_0:0:000000000", "STEAM_0:0:0000000000" }
local masks   = { "        1 9", "        1 99", "        1 999", "        1 9999", "        1 99999", "        1 999999", "        1 9999999", "        1 99999999", "        1 999999999", "        1 9999999999" }

local maskMapping = { [" "] = "\x00", ["1"] = "\x01", ["9"] = "\x0F", ["A"] = "\x20" }
for i = 1, #masks do
	masks[i] = string.gsub(masks[i], ".", maskMapping)
end

local unpack = unpack
local string_byte = string.byte
local string_char = string.char

local function permute(format0, mask, v)
	local s = {}
	local x = 0
	for i = 1, #mask do
		local mask = string_byte(mask, i)
		local c    = string_byte(format0, i)
		local dc = 1
		for j = 1, 8 do
			local b = mask % 2
			if b > 0 then
				c = c + v[x] * dc * b
				x = x + b
			end
			mask = (mask - b) * 0.5
			dc = dc * 2
		end
		s[#s + 1] = c
	end
	return string_char(unpack(s))
end

local function collide(crc32, format, mask, out)
	local out = out or {}
	
	local w = 0
	local format0 = ""
	for i = 1, #mask do
		local mask = string.byte(mask, i)
		format0 = format0 .. string.char(bit.band(string.byte(format, i), bit.bnot(mask)))
		while mask > 0 do
			local b = mask % 2
			w = w + b
			mask = (mask - b) * 0.5
		end
	end
	
	local y0 = Cat.GF2Matrix.ColumnFromUInt32(tonumber(CRC32("gm_" .. format0 .. "_gm")))
	local b = Cat.GF2Matrix.ColumnFromUInt32(crc32) - y0
	local y = Cat.GF2Matrix(32, 1)
	local A = Cat.GF2Matrix(32, w)
	
	local x = 0
	for i = 1, #mask do
		local mask = string.byte(mask, i)
		local c0   = string.byte(format0, i)
		local dc = 1
		for j = 1, 8 do
			local b = mask % 2
			if b > 0 then
				local f = string.sub(format0, 1, i - 1) .. string.char(c0 + dc) .. string.sub(format0, i + 1)
				y = Cat.GF2Matrix.ColumnFromUInt32(tonumber(CRC32("gm_" .. f .. "_gm")), y)
				y = y:Subtract(y0, y)
				A:SetColumn(x, y)
				x = x + 1
			end
			mask = (mask - b) * 0.5
			dc = dc * 2
		end
	end
	
	local x0, nullSpace = A:Solve(b)
	
	if x0 then
		local x = nil
		for i = 0, 2 ^ #nullSpace - 1 do
			x = x0:Clone(x)
			for j = 0, #nullSpace - 1 do
				if bit.band(i, 2 ^ j) ~= 0 then
					x = x:Add(nullSpace[j + 1], x)
				end
			end
			
			out[#out + 1] = permute(format0, mask, x)
		end
	end
	
	return out
end

return function(uniqueId)
	local collisions = {}
	for i = 1, #formats do
		local unfilteredCollisions = collide(uniqueId, formats[i], masks[i])
		for i = 1, #unfilteredCollisions do
			local x = string.match(unfilteredCollisions[i], "^STEAM_0:%d:(%d+)$")
			if x and
			   string.sub(x, 1, 1) ~= "0" and
			   tonumber(x) <= 0x7FFFFFFF then
				collisions[#collisions + 1] = unfilteredCollisions[i]
			end
		end
	end
	
	return collisions
end
