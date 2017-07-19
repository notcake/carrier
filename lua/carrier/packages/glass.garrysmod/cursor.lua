Cursor = {}

local nativeToCursor = {}
nativeToCursor ["no"]        = Glass.Cursor.None
nativeToCursor ["arrow"]     = Glass.Cursor.Arrow
nativeToCursor ["beam"]      = Glass.Cursor.Beam
nativeToCursor ["hand"]      = Glass.Cursor.Hand
nativeToCursor ["hourglass"] = Glass.Cursor.Hourglass
nativeToCursor ["sizenwse"]  = Glass.Cursor.SizeNorthWestSouthEast
nativeToCursor ["sizenesw"]  = Glass.Cursor.SizeNorthEastSouthWest
nativeToCursor ["sizewe"]    = Glass.Cursor.SizeEastWest
nativeToCursor ["sizens"]    = Glass.Cursor.SizeNorthSouth

local Table = require ("Pylon.Table")
local cursorToNative = Table.Invert (nativeToCursor)
cursorToNative [Glass.Cursor.Default] = "arrow"

function Cursor.FromNative (cursor)
	return nativeToCursor [cursor]
end

function Cursor.ToNative (cursor)
	return cursorToNative [cursor]
end
