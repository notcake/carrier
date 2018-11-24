-- PACKAGE Pylon.IO.Lua

Lua = {}

Error = require("Pylon.Error")
OOP   = require("Pylon.OOP")
OOP.Initialize(_ENV)
BitConverter = require("Pylon.BitConverter")
IO = require("Pylon.IO")
IO.Initialize(Lua)

include("filestream.lua")
include("fileinputstream.lua")
include("fileoutputstream.lua")

function Lua.Initialize(destinationTable)
	destinationTable = destinationTable or {}
	
	destinationTable = IO.Initialize(destinationTable)
	
	destinationTable.FileStream       = Lua.FileStream
	destinationTable.FileInputStream  = Lua.FileInputStream
	destinationTable.FileOutputStream = Lua.FileOutputStream
	
	return destinationTable
end

return Lua
