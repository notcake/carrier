-- PACKAGE Pylon.Socket

Socket = {}

Error = require ("Pylon.Error")
OOP   = require ("Pylon.OOP")
OOP.Initialize (_ENV)

if jit.os == "Windows" then
	include ("winsock.lua")
elseif jit.os == "Linux" then
	include ("socket.lua")
end

include ("tcp.lua")

return Socket
