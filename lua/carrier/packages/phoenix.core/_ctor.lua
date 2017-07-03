Core = {}

Error = require ("Pylon.Error")

OOP = require ("Pylon.OOP")
OOP.Initialize (_ENV)

include ("iview.lua")
include ("iwindow.lua")

function Core.Initialize (destinationTable)
	destinationTable = destinationTable or {}
	
	destinationTable.IView      = Core.IView
	destinationTable.IContainer = Core.IContainer
	destinationTable.IWindow    = Core.IWindow
	
	return destinationTable
end

return Core
