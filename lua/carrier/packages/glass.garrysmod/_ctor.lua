-- PACKAGE Glass.GarrysMod

GarrysMod = {}

require ("Pylon.OOP").Initialize (_ENV)

Clock = require ("Pylon.MonotonicClock")

require ("Pylon.Enumeration").Initialize (_ENV)

Color = require ("Pylon.Color")

Glass = require ("Glass")
Glass.Initialize (GarrysMod)

Photon = require ("Photon.GarrysMod")

FontCache = require ("GarrysMod.FontCache")

include ("mouse/cursor.lua")
include ("mouse/mousebuttons.lua")
include ("mouse/mouseeventrouter.lua")

include ("keyboard/keyboard.lua")

include ("layout/contentalignment.lua")

include ("window.lua")
include ("window.restorebutton.lua")

include ("externalview.lua")

include ("environment.lua")

-- Desktop
include ("desktop.lua")
include ("desktopitem.lua")

MouseEventRouter = MouseEventRouter ()
GarrysMod.Desktop = Desktop ()

return GarrysMod
