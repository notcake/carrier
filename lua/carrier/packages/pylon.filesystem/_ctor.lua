local FileSystem = {}

Error = require ("Pylon.Error")
OOP   = require ("Pylon.OOP")
OOP.Initialize (_ENV)

Task = require ("Pylon.Task")

include ("nodetype.lua")
include ("filemode.lua")
include ("ifilesystem.lua")

return FileSystem
