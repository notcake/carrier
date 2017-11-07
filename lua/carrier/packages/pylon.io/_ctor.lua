-- PACKAGE Pylon.IO

IO = {}

Error = require ("Pylon.Error")
OOP   = require ("Pylon.OOP")
OOP.Initialize (_ENV)
BitConverter = require ("Pylon.BitConverter")

include ("ibasestream.lua")
include ("iinputstream.lua")
include ("ioutputstream.lua")

include ("endianness.lua")
include ("istreamreader.lua")
include ("istreamwriter.lua")

include ("streamreader.lua")
include ("streamwriter.lua")

include ("bufferedstreamreader.lua")
include ("bufferedstreamwriter.lua")

include ("stringinputstream.lua")
include ("stringoutputstream.lua")

function IO.Initialize (destinationTable)
	destinationTable = destinationTable or {}
	
	destinationTable.IBaseStream          = IO.IBaseStream
	destinationTable.IInputStream         = IO.IInputStream
	destinationTable.IOutputStream        = IO.IOutputStream
	
	destinationTable.Endianness           = IO.Endianness
	destinationTable.IStreamReader        = IO.IStreamReader
	destinationTable.IStreamWriter        = IO.IStreamWriter
	
	destinationTable.StreamReader         = IO.StreamReader
	destinationTable.StreamWriter         = IO.StreamWriter
	
	destinationTable.BufferedStreamReader = IO.BufferedStreamReader
	destinationTable.BufferedStreamWriter = IO.BufferedStreamWriter
	
	destinationTable.StringInputStream    = IO.StringInputStream
	destinationTable.StringOutputStream   = IO.StringOutputStream
	
	return destinationTable
end

return IO
