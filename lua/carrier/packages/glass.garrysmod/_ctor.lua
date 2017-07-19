GarrysMod = {}

require ("Pylon.OOP").Initialize (_ENV)

Clock = require ("Pylon.MonotonicClock")

Color = require ("Pylon.Color")

Glass = require ("Glass")
Glass.Initialize (_ENV)
Glass.Initialize (GarrysMod)

Photon = require ("Photon")

include ("font.lua")

include ("defaultskin.lua")

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

-- Extras
GarrysMod.ListView      = Glass.ListView (GarrysMod)
GarrysMod.TableView     = Glass.TableView (GarrysMod)
GarrysMod.TreeTableView = Glass.TreeTableView (GarrysMod)

GarrysMod.Desktop = Desktop ()

GarrysMod.TextRenderer = Photon.TextRenderer

return GarrysMod
