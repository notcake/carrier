Core = {}

Error = require ("Pylon.Error")

OOP = require ("Pylon.OOP")
OOP.Initialize (_ENV)

include ("irender2d.lua")

function Core.Initialize (destinationTable)
	destinationTable = destinationTable or {}
	
	destinationTable.IRender2d = Core.IRender2d
	
	return destinationTable
end

return Core
