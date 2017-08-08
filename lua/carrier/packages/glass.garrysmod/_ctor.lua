GarrysMod = {}

require ("Pylon.OOP").Initialize (_ENV)

Clock = require ("Pylon.MonotonicClock")

Color = require ("Pylon.Color")

Glass = require ("Glass")
Glass.Initialize (_ENV)
Glass.Initialize (GarrysMod)

Photon = require ("Photon.GarrysMod")

include ("environment.lua")

include ("fonts/font.lua")

include ("defaultskin.lua")

include ("mouse/cursor.lua")
include ("mouse/mousebuttons.lua")
include ("mouse/mouseeventrouter.lua")

include ("keyboard/keyboard.lua")

include ("layout/contentalignment.lua")

include ("view.lua")
include ("window.lua")
include ("window.restorebutton.lua")
include ("label.lua")

include ("scrollbars/scrollbar.lua")
include ("scrollbars/scrollbar.button.lua")
include ("scrollbars/scrollbar.buttonbehaviour.lua")
include ("scrollbars/scrollbar.grip.lua")
include ("scrollbars/verticalscrollbar.lua")
include ("scrollbars/horizontalscrollbar.lua")
include ("scrollbars/scrollbarcorner.lua")

include ("externalview.lua")

-- Desktop
include ("desktop.lua")
include ("desktopitem.lua")

-- Extras
GarrysMod.ListView      = Glass.ListView (GarrysMod)
GarrysMod.ListViewItem  = Glass.ListViewItem (GarrysMod)
GarrysMod.TableView     = Glass.TableView (GarrysMod)
GarrysMod.TableViewItem = Glass.TableViewItem (GarrysMod)
GarrysMod.TreeTableView = Glass.TreeTableView (GarrysMod)

MouseEventRouter = MouseEventRouter ()
GarrysMod.Desktop = Desktop ()

return GarrysMod
