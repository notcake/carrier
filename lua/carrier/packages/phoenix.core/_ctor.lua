Core = {}

Error = require ("Pylon.Error")

OOP = require ("Pylon.OOP")
OOP.Initialize (_ENV)

include ("mousebuttons.lua")

include ("iview.lua")
include ("iwindow.lua")

function Core.Initialize (destinationTable)
	destinationTable = destinationTable or {}
	
	destinationTable.MouseButtons = Core.MouseButtons
	destinationTable.IView        = Core.IView
	destinationTable.IWindow      = Core.IWindow
	
	return destinationTable
end

return Core
