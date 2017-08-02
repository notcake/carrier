GarrysMod = {}

require ("Pylon.OOP").Initialize (_ENV)

Clock = require ("Pylon.MonotonicClock")

Color = require ("Pylon.Color")

Glass = require ("Glass")
Glass.Initialize (_ENV)
Glass.Initialize (GarrysMod)

Photon = require ("Photon")

include ("fonts/font.lua")

include ("defaultskin.lua")

include ("mouse/cursor.lua")
include ("mouse/mousebuttons.lua")
include ("mouse/mouseeventrouter.lua")

include ("layout/contentalignment.lua")

include ("panelviews.lua")

include ("view.lua")
include ("window.lua")
include ("window.restorebutton.lua")
include ("label.lua")

include ("scrollbar.lua")
include ("scrollbar.button.lua")
include ("scrollbar.grip.lua")
include ("verticalscrollbar.lua")
include ("horizontalscrollbar.lua")
include ("scrollbarcorner.lua")

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

GarrysMod.TextRenderer = Photon.TextRenderer

return GarrysMod
