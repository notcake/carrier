-- PACKAGE Zondicons
-- http://www.zondicons.com/

Zondicons = {}

Svg = require ("Jotun.Svg")
require ("Pylon.Enumeration").Initialize (_ENV)

Zondicons.Images = {}

include ("files.lua")

Zondicons.Names = {}
for name, _ in pairs (Zondicons.Files) do
	Zondicons.Names [#Zondicons.Names + 1] = name
end
table.sort (Zondicons.Names)

function Zondicons.Get (name)
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

return Zondicons
