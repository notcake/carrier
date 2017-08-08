Photon = {}

Error = require ("Pylon.Error")

OOP = require ("Pylon.OOP")
OOP.Initialize (_ENV)

include ("irender2d.lua")

function Photon.Initialize (destinationTable)
	destinationTable = destinationTable or {}
	
	destinationTable.IRender2d = Photon.IRender2d
	
	return destinationTable
end

return Photon
