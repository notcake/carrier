IO = {}

Error = CakeStrap.LoadPackage ("Knotcake.Error")
OOP = CakeStrap.LoadPackage ("Knotcake.OOP")
OOP.Initialize (_ENV)
BitConverter = CakeStrap.LoadPackage ("Knotcake.BitConverter")

include ("ibasestream.lua")
include ("iinstream.lua")
include ("ioutstream.lua")

include ("endianness.lua")
include ("istreamreader.lua")
include ("istreamwriter.lua")

include ("streamreader.lua")
include ("streamwriter.lua")

include ("bufferedstreamreader.lua")
include ("bufferedstreamwriter.lua")

include ("stringinstream.lua")
include ("stringoutstream.lua")

function IO.Initialize (destinationTable)
	destinationTable = destinationTable or {}
	
	destinationTable.IBaseStream          = IO.IBaseStream
	destinationTable.IInStream            = IO.IInStream
	destinationTable.IOutStream           = IO.IOutStream
	
	destinationTable.Endianness           = IO.Endianness
	destinationTable.IStreamReader        = IO.IStreamReader
	destinationTable.IStreamWriter        = IO.IStreamWriter
	
	destinationTable.StreamReader         = IO.StreamReader
	destinationTable.StreamWriter         = IO.StreamWriter
	
	destinationTable.BufferedStreamReader = IO.BufferedStreamReader
	destinationTable.BufferedStreamWriter = IO.BufferedStreamWriter
	
	destinationTable.StringInStream       = IO.StringInStream
	destinationTable.StringOutStream      = IO.StringOutStream
	
	return destinationTable
end

return IO
