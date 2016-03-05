GarrysMod = {}

Error = CakeStrap.LoadPackage ("Knotcake.Error")
OOP   = CakeStrap.LoadPackage ("Knotcake.OOP")
OOP.Initialize (_ENV)
BitConverter = CakeStrap.LoadPackage ("Knotcake.BitConverter")
IO = CakeStrap.LoadPackage ("Knotcake.IO")
IO.Initialize (GarrysMod)

include ("fileinstream.lua")
include ("fileoutstream.lua")
include ("netinstream.lua")
include ("netoutstream.lua")
include ("usermessageinstream.lua")
include ("usermessageoutstream.lua")

function GarrysMod.Initialize (destinationTable)
	destinationTable = destinationTable or {}
	
	destinationTable = IO.Initialize (destinationTable)
	
	destinationTable.FileInStream         = GarrysMod.FileInStream
	destinationTable.FileOutStream        = GarrysMod.FileOutStream
	
	destinationTable.NetInStream          = GarrysMod.NetInStream
	destinationTable.NetOutStream         = GarrysMod.NetOutStream
	
	destinationTable.UsermessageInStream  = GarrysMod.UsermessageInStream
	destinationTable.UsermessageOutStream = GarrysMod.UsermessageOutStream
	
	return destinationTable
end

return GarrysMod
