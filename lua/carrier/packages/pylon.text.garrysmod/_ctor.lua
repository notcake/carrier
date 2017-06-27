GarrysMod = {}

Error = require ("Pylon.Error")

OOP = require ("Pylon.OOP")
OOP.Initialize (_ENV)

Text = require ("Pylon.Text")
Text.Initialize (GarrysMod)

include ("util.lua")
include ("linebufferedtextsink.lua")

include ("consoletextsink.lua")
include ("chattextsink.lua")
include ("remotechattextsink.lua")

function GarrysMod.Initialize (destinationTable)
	destinationTable = destinationTable or {}
	
	destinationTable = Text.Initialize (destinationTable)
	
	destinationTable.ConsoleTextSink    = GarrysMod.ConsoleTextSink
	destinationTable.ChatTextSink       = GarrysMod.ChatTextSink
	destinationTable.RemoteChatTextSink = GarrysMod.RemoteChatTextSink
	
	return destinationTable
end

return GarrysMod
