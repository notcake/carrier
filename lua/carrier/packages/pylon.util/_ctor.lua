Util = {}

Error = require ("Pylon.Error")
OOP   = require ("Pylon.OOP")
OOP.Initialize (_ENV)

include ("duration.lua")
include ("filesize.lua")

include ("isavable.lua")
include ("autosaver.lua")

return Util
