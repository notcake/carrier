GarrysMod = {}

GarrysMod.Error = CakeStrap.LoadPackage ("Knotcake.Error")
GarrysMod.OOP   = CakeStrap.LoadPackage ("Knotcake.OOP")
GarrysMod.OOP.Initialize (GarrysMod)
GarrysMod.BitConverter = CakeStrap.LoadPackage ("Knotcake.BitConverter")
GarrysMod.IO = CakeStrap.LoadPackage ("Knotcake.IO")

include ("knotcake.io.garrysmod/fileinstream.lua")
include ("knotcake.io.garrysmod/fileoutstream.lua")
include ("knotcake.io.garrysmod/netinstream.lua")
include ("knotcake.io.garrysmod/netoutstream.lua")

return IO
