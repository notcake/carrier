-- PACKAGE Jotun.Xml

Xml = {}

Error = require("Pylon.Error")

require("Pylon.OOP").Initialize(_ENV)

require("Pylon.Enumeration").Initialize(_ENV)

StringParser = require("Eka.StringParser")

include("nodetype.lua")
include("tagtype.lua")
include("node.lua")
include("elementnode.lua")
include("commentnode.lua")
include("textnode.lua")
include("parser.lua")

local escapes =
{
	["&"] = "&amp;",
	["<"] = "&lt;",
	[">"] = "&gt;",
	["\""] = "&quot;"
}

function Xml.Escape(str)
	return string.gsub(str, "[&<>\"]", escapes)
end

function Xml.Parse(str)
	return Xml.ParseDom(str)
end

function Xml.ParseDom(str)
	local parser = Parser(str)
	return parser:GetDocument()
end

function Xml.ParseSax(str, yield)
	Parser(str, yield)
end
Xml.ParseSax = YieldEnumeratorFactory(Xml.ParseSax)

return Xml
