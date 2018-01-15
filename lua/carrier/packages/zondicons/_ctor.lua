-- PACKAGE Zondicons
-- http://www.zondicons.com/

Zondicons = {}

Array  = require ("Pylon.Array")
Map    = require ("Pylon.Map")
String = require ("Pylon.String")
Svg    = require ("Jotun.Svg")
require ("Pylon.Enumeration").Initialize (_ENV)

Zondicons.Images = {}

include ("files.lua")

local nameMap = {}
for k, _ in pairs (Zondicons.Files) do
	local name = table.concat (Array.Map (String.Split (k, "-"), String.Ascii.ToTitle))
	nameMap [name] = k
end

Zondicons.Names = Map.Keys (nameMap)
table.sort (Zondicons.Names)

function Zondicons.Get (name)
	local name = nameMap [name] or name
	
	if Zondicons.Images [name] then
		return Zondicons.Images [name]
	end
	
	if not Zondicons.Files [name] then return nil end
	
	Zondicons.Images [name] = Svg.Image.FromXml (Zondicons.Files [name])
	
	return Zondicons.Images [name]
end

function Zondicons.GetEnumerator ()
	return ArrayEnumerator (Zondicons.Names):Map (function (name) return name, Zondicons.Get (name) end)
end

setmetatable (Zondicons,
	{
		__index = function (_, name)
			return Zondicons.Get (name)
		end
	}
)

return Zondicons
