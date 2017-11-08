-- PACKAGE Glass

Glass = {}

Error = require ("Pylon.Error")

Table = require ("Pylon.Table")

require ("Pylon.OOP").Initialize (_ENV)

Clock = require ("Pylon.MonotonicClock")

require ("Pylon.Enumeration").Initialize (_ENV)

ICollection = require ("Pylon.Containers.ICollection")
CompactList = require ("Pylon.Containers.CompactList")

Pool = require ("Pylon.Pool")

Color = require ("Pylon.Color")

Photon = require ("Photon")

include ("ienvironment.lua")

include ("iskin.lua")
include ("skin.lua")

include ("fonts/fontweight.lua")
include ("fonts/ifont.lua")
include ("fonts/font.lua")
include ("textclass.lua")

include ("layout/horizontalalignment.lua")
include ("layout/verticalalignment.lua")
include ("layout/orientation.lua")
include ("layout/direction.lua")

include ("mouse/cursor.lua")
include ("mouse/mousebuttons.lua")

include ("keyboard/ikeyboard.lua")

include ("behaviours/buttonbehaviour.lua")
include ("behaviours/dragbehaviour.lua")

include ("iview.lua")
include ("ilabel.lua")
include ("ibutton.lua")
include ("iwindow.lua")

include ("animations/ianimation.lua")
include ("animations/ianimator.lua")
include ("animations/animation.lua")
include ("animations/animator.lua")
include ("animations/valueanimator.lua")
include ("animations/vector2danimator.lua")
include ("animations/rectangleanimator.lua")
include ("animations/interpolators.lua")

include ("view.lua")
include ("label.lua")

include ("scrollbars/scrollbar.lua")
include ("scrollbars/scrollbar.button.lua")
include ("scrollbars/scrollbar.button.glyphs.lua")
include ("scrollbars/scrollbar.buttonbehaviour.lua")
include ("scrollbars/scrollbar.grip.lua")
include ("scrollbars/verticalscrollbar.lua")
include ("scrollbars/horizontalscrollbar.lua")
include ("scrollbars/scrollbarcorner.lua")

include ("containers/listview.lua")
include ("containers/ilistviewdatasource.lua")
include ("containers/listviewitem.lua")
include ("containers/listview.internaldatasource.lua")
include ("containers/tableview.lua")
include ("containers/tableviewitem.lua")
include ("containers/tableview.listviewitem.lua")
include ("containers/tableview.listviewitem.customrenderedview.lua")
include ("containers/tableview.internaldatasource.lua")
include ("containers/tableview.header.lua")
include ("containers/tableview.columnview.lua")
include ("containers/tableview.columnresizegrip.lua")
include ("containers/tableview.columncollection.lua")
include ("containers/itableviewdatasource.lua")
include ("containers/tableviewcolumn.lua")
include ("containers/tableviewcolumntype.lua")
include ("containers/treetableview.lua")

function Glass.Initialize (destinationTable)
	destinationTable = destinationTable or {}
	
	destinationTable.IEnvironment           = Glass.IEnvironment
	
	destinationTable.ISkin                  = Glass.ISkin
	destinationTable.Skin                   = Glass.Skin
	
	destinationTable.FontWeight             = Glass.FontWeight
	destinationTable.IFont                  = Glass.IFont
	destinationTable.Font                   = Glass.Font
	destinationTable.TextClass              = Glass.TextClass
	
	destinationTable.HorizontalAlignment    = Glass.HorizontalAlignment
	destinationTable.VerticalAlignment      = Glass.VerticalAlignment
	destinationTable.Orientation            = Glass.Orientation
	destinationTable.Direction              = Glass.Direction
	
	destinationTable.Cursor                 = Glass.Cursor
	destinationTable.MouseButtons           = Glass.MouseButtons
	
	destinationTable.IKeyboard              = Glass.IKeyboard
	
	destinationTable.IView                  = Glass.IView
	destinationTable.ILabel                 = Glass.ILabel
	destinationTable.IButton                = Glass.IButton
	destinationTable.IWindow                = Glass.IWindow
	
	destinationTable.IAnimation             = Glass.IAnimation
	destinationTable.IAnimator              = Glass.IAnimator
	destinationTable.Animation              = Glass.Animation
	destinationTable.Animator               = Glass.Animator
	destinationTable.ValueAnimator          = Glass.ValueAnimator
	destinationTable.Vector2dAnimator       = Glass.Vector2dAnimator
	destinationTable.RectangleAnimator      = Glass.RectangleAnimator
	
	destinationTable.Interpolators          = Glass.Interpolators
	
	destinationTable.View                   = Glass.View
	destinationTable.Label                  = Glass.Label
	
	destinationTable.VerticalScrollbar      = Glass.VerticalScrollbar
	destinationTable.HorizontalScrollbar    = Glass.HorizontalScrollbar
	destinationTable.ScrollbarCorner        = Glass.ScrollbarCorner
	
	destinationTable.IListViewDataSource    = Glass.IListViewDataSource
	destinationTable.ITableViewDataSource   = Glass.ITableViewDataSource
	
	destinationTable.ListView               = Glass.ListView
	destinationTable.ListViewItem           = Glass.ListViewItem
	destinationTable.TableView              = Glass.TableView
	destinationTable.TableViewColumn        = Glass.TableViewColumn
	destinationTable.TableViewColumnType    = Glass.TableViewColumnType
	destinationTable.TableViewItem          = Glass.TableViewItem
	destinationTable.TreeTableView          = Glass.TreeTableView
	
	return destinationTable
end

return Glass
