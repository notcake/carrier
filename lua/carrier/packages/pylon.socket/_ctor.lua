-- PACKAGE Pylon.Socket

Socket = {}

Error = require ("Pylon.Error")
OOP   = require ("Pylon.OOP")
OOP.Initialize (_ENV)

include ("winsock.lua")
include ("tcp.lua")

return Socket
