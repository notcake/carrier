Util = {}

Error = CakeStrap.LoadPackage ("Knotcake.Error")
OOP   = CakeStrap.LoadPackage ("Knotcake.OOP")
OOP.Initialize (_ENV)

include ("duration.lua")
include ("filesize.lua")

include ("isavable.lua")
include ("autosaver.lua")

return Util
