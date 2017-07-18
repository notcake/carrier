Cursor = {}

local nativeToCursor = {}
nativeToCursor ["no"]        = Phoenix.Cursor.None
nativeToCursor ["arrow"]     = Phoenix.Cursor.Arrow
nativeToCursor ["beam"]      = Phoenix.Cursor.Beam
nativeToCursor ["hand"]      = Phoenix.Cursor.Hand
nativeToCursor ["hourglass"] = Phoenix.Cursor.Hourglass
nativeToCursor ["sizenwse"]  = Phoenix.Cursor.SizeNorthWestSouthEast
nativeToCursor ["sizenesw"]  = Phoenix.Cursor.SizeNorthEastSouthWest
nativeToCursor ["sizewe"]    = Phoenix.Cursor.SizeEastWest
nativeToCursor ["sizens"]    = Phoenix.Cursor.SizeNorthSouth

local Table = require ("Pylon.Table")
local cursorToNative = Table.Invert (nativeToCursor)
cursorToNative [Phoenix.Cursor.Default] = "arrow"

function Cursor.FromNative (cursor)
	return nativeToCursor [cursor]
end

function Cursor.ToNative (cursor)
	return cursorToNative [cursor]
end
