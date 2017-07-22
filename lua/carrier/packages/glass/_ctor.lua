Glass = {}

Error = require ("Pylon.Error")

OOP = require ("Pylon.OOP")
OOP.Initialize (_ENV)

include ("fonts/ifont.lua")
include ("fonts/fontweight.lua")

include ("layout/horizontalalignment.lua")
include ("layout/verticalalignment.lua")

include ("mouse/cursor.lua")
include ("mouse/mousebuttons.lua")

include ("iview.lua")
include ("iwindow.lua")

include ("containers/listview.lua")
include ("containers/ilistviewdatasource.lua")
include ("containers/tableview.lua")
include ("containers/treetableview.lua")

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
	
	destinationTable.IListViewDataSource = Glass.IListViewDataSource
	
	return destinationTable
end

return Glass
