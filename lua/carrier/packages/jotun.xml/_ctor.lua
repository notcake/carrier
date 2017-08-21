Xml = {}

Error = require ("Pylon.Error")

require ("Pylon.OOP").Initialize (_ENV)

require ("Pylon.Enumeration").Initialize (_ENV)

ICollection = require ("Pylon.Containers.ICollection")

StringParser = require ("Eka.StringParser")

include ("nodetype.lua")
include ("tagtype.lua")
include ("node.lua")
include ("elementnode.lua")
include ("commentnode.lua")
include ("textnode.lua")
include ("parse.lua")

local escapes =
{
	["&"] = "&amp;",
	["<"] = "&lt;",
	[">"] = "&gt;",
	["\""] = "&quot;"
}

function Xml.Escape (str)
	return string.gsub (str, "[&<>\"]", escapes)
end

return Xml
