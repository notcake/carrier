GarrysMod = {}

require ("Pylon.OOP").Initialize (_ENV)

Phoenix = require ("Phoenix")
Phoenix.Initialize (_ENV)

Photon = require ("Photon")

Clock = require ("Pylon.MonotonicClock")

include ("font.lua")

include ("cursor.lua")
include ("mousebuttons.lua")

include ("panelviews.lua")

include ("view.lua")
include ("window.lua")
include ("window.restorebutton.lua")
include ("label.lua")

include ("externalview.lua")

-- Desktop
include ("desktop.lua")
include ("desktopitem.lua")

GarrysMod.Desktop = Desktop ()

GarrysMod.TextRenderer = Photon.TextRenderer

function GarrysMod.Initialize (destinationTable)
	destinationTable = destinationTable or {}
	
	Phoenix.Initialize (destinationTable)
	
	destinationTable.Font         = GarrysMod.Font
	
	destinationTable.View         = GarrysMod.View
	destinationTable.Window       = GarrysMod.Window
	destinationTable.Label        = GarrysMod.Label
	
	destinationTable.Desktop      = GarrysMod.Desktop
	
	destinationTable.TextRenderer = GarrysMod.TextRenderer
	
	return destinationTable
end

return GarrysMod
