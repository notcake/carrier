GarrysMod = {}

require ("Pylon.OOP").Initialize (_ENV)

Clock = require ("Pylon.MonotonicClock")

Color = require ("Pylon.Color")

Phoenix = require ("Phoenix")
Phoenix.Initialize (_ENV)
Phoenix.Initialize (GarrysMod)

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
GarrysMod.ListView      = Phoenix.ListView (GarrysMod)
GarrysMod.TableView     = Phoenix.TableView (GarrysMod)
GarrysMod.TreeTableView = Phoenix.TreeTableView (GarrysMod)

GarrysMod.Desktop = Desktop ()

GarrysMod.TextRenderer = Photon.TextRenderer

return GarrysMod
