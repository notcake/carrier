Glass = {}

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

function Glass.Initialize (destinationTable)
	destinationTable = destinationTable or {}
	
	destinationTable.IFont               = Glass.IFont
	destinationTable.FontWeight          = Glass.FontWeight
	
	destinationTable.HorizontalAlignment = Glass.HorizontalAlignment
	destinationTable.VerticalAlignment   = Glass.VerticalAlignment
	
	destinationTable.Cursor              = Glass.Cursor
	destinationTable.MouseButtons        = Glass.MouseButtons
	destinationTable.IView               = Glass.IView
	destinationTable.IWindow             = Glass.IWindow
	
	return destinationTable
end

return Glass
