Cursor = {}

local nativeToCursor = {}
nativeToCursor ["no"]        = Core.Cursor.None
nativeToCursor ["arrow"]     = Core.Cursor.Arrow
nativeToCursor ["beam"]      = Core.Cursor.Beam
nativeToCursor ["hand"]      = Core.Cursor.Hand
nativeToCursor ["hourglass"] = Core.Cursor.Hourglass
nativeToCursor ["sizenwse"]  = Core.Cursor.SizeNorthWestSouthEast
nativeToCursor ["sizenesw"]  = Core.Cursor.SizeNorthEastSouthWest
nativeToCursor ["sizewe"]    = Core.Cursor.SizeEastWest
nativeToCursor ["sizens"]    = Core.Cursor.SizeNorthSouth

local Table = require ("Pylon.Table")
local cursorToNative = Table.Invert (nativeToCursor)
cursorToNative [Core.Cursor.Default] = "arrow"

function Cursor.FromNative (cursor)
	return nativeToCursor [cursor]
end

function Cursor.ToNative (cursor)
	return cursorToNative [cursor]
end
