Text = {}

Error = Carrier.LoadPackage ("Pylon.Error")

OOP = Carrier.LoadPackage ("Pylon.OOP")
OOP.Initialize (_ENV)

include ("itextsink.lua")
include ("icoloredtextsink.lua")

include ("nulltextsink.lua")

function Text.Initialize (destinationTable)
	destinationTable = destinationTable or {}
	
	destinationTable.ITextSink        = Text.ITextSink
	destinationTable.IColoredTextSink = Text.IColoredTextSink
	
	destinationTable.NullTextSink     = Text.NullTextSink
	
	return destinationTable
end

return Text
