GarrysMod = {}

Error = Carrier.LoadPackage ("Pylon.Error")
OOP   = Carrier.LoadPackage ("Pylon.OOP")
OOP.Initialize (_ENV)
BitConverter = Carrier.LoadPackage ("Pylon.BitConverter")
IO = Carrier.LoadPackage ("Pylon.IO")
IO.Initialize (GarrysMod)

include ("fileinputstream.lua")
include ("fileoutputstream.lua")
include ("netinputstream.lua")
include ("netoutputstream.lua")
include ("usermessageinputstream.lua")
include ("usermessageoutputstream.lua")

function GarrysMod.Initialize (destinationTable)
	destinationTable = destinationTable or {}
	
	destinationTable = IO.Initialize (destinationTable)
	
	destinationTable.FileInputStream         = GarrysMod.FileInputStream
	destinationTable.FileOutputStream        = GarrysMod.FileOutputStream
	
	destinationTable.NetInputStream          = GarrysMod.NetInputStream
	destinationTable.NetOutputStream         = GarrysMod.NetOutputStream
	
	destinationTable.UsermessageInputStream  = GarrysMod.UsermessageInputStream
	destinationTable.UsermessageOutputStream = GarrysMod.UsermessageOutputStream
	
	return destinationTable
end

return GarrysMod
