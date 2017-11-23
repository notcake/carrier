-- PACKAGE Carrier

Carrier = {}

Error = require ("Pylon.Error")
OOP   = require ("Pylon.OOP")
OOP.Initialize (_ENV)

IO = require ("Pylon.IO")

Enumeration = require ("Pylon.Enumeration")
Enumeration.Initialize (_ENV)

Array = require ("Pylon.Array")
Async = require_provider ("Pylon.Async")
HTTP  = require_provider ("Pylon.HTTP")
Task  = require ("Pylon.Task")

Clock = require_provider ("Pylon.MonotonicClock")

include ("packages.lua")
include ("package.lua")
include ("ipackagerelease.lua")
include ("packagerelease.lua")
include ("localdeveloperpackagerelease.lua")
include ("remotedeveloperpackagerelease.lua")
include ("publickey.lua")

function Carrier.ToFileName (s)
	return string.gsub (string.lower (s), "[^%w%.%-%+_]", "_")
end

function Carrier.Log (message)
	print ("Carrier: " .. message)
end

function Carrier.Warning (message)
	print ("Carrier: Warning: " .. message)
end

Carrier.Packages = Carrier.Packages ()

return Carrier
