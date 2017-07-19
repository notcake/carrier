Phoenix = {}

Error = require ("Pylon.Error")

OOP = require ("Pylon.OOP")
OOP.Initialize (_ENV)

include ("ifont.lua")
include ("fontweight.lua")

include ("horizontalalignment.lua")
include ("verticalalignment.lua")

include ("cursor.lua")
include ("mousebuttons.lua")

include ("iview.lua")
include ("iwindow.lua")

include ("listview.lua")
include ("tableview.lua")
include ("treetableview.lua")

function Phoenix.Initialize (destinationTable)
	destinationTable = destinationTable or {}
	
	destinationTable.IFont               = Phoenix.IFont
	destinationTable.FontWeight          = Phoenix.FontWeight
	
	destinationTable.HorizontalAlignment = Phoenix.HorizontalAlignment
	destinationTable.VerticalAlignment   = Phoenix.VerticalAlignment
	
	destinationTable.Cursor              = Phoenix.Cursor
	destinationTable.MouseButtons        = Phoenix.MouseButtons
	destinationTable.IView               = Phoenix.IView
	destinationTable.IWindow             = Phoenix.IWindow
	
	return destinationTable
end

return Phoenix
