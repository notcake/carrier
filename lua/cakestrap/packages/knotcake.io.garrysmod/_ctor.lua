GarrysMod = {}

GarrysMod.Error = CakeStrap.LoadPackage ("Knotcake.Error")
GarrysMod.OOP   = CakeStrap.LoadPackage ("Knotcake.OOP")
GarrysMod.OOP.Initialize (GarrysMod)
GarrysMod.BitConverter = CakeStrap.LoadPackage ("Knotcake.BitConverter")
GarrysMod.IO = CakeStrap.LoadPackage ("Knotcake.IO")

include ("fileinstream.lua")
include ("fileoutstream.lua")
include ("netinstream.lua")
include ("netoutstream.lua")
include ("usermessageinstream.lua")
include ("usermessageoutstream.lua")

return IO
