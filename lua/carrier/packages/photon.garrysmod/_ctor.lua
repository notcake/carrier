GarrysMod = {}

require ("Pylon.OOP").Initialize (_ENV)

Core = require ("Photon.Core")
Core.Initialize (_ENV)

include ("render2d.lua")

function GarrysMod.Initialize (destinationTable)
	destinationTable = destinationTable or {}
	
	Core.Initialize (destinationTable)
	
	destinationTable.Render2d = GarrysMod.Render2d
	
	return destinationTable
end

return GarrysMod
