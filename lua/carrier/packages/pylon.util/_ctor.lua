Util = {}

Error = Carrier.LoadPackage ("Pylon.Error")
OOP   = Carrier.LoadPackage ("Pylon.OOP")
OOP.Initialize (_ENV)

include ("duration.lua")
include ("filesize.lua")

include ("isavable.lua")
include ("autosaver.lua")

return Util
