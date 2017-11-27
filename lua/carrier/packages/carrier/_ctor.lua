-- PACKAGE Carrier

Carrier = {}

Error = require ("Pylon.Error")
OOP   = require ("Pylon.OOP")
OOP.Initialize (_ENV)

IO = require_provider ("Pylon.IO")

Enumeration = require ("Pylon.Enumeration")
Enumeration.Initialize (_ENV)

Array  = require ("Pylon.Array")
Async  = require_provider ("Pylon.Async")
Base64 = require ("Pylon.Base64")
HTTP   = require_provider ("Pylon.HTTP")
Task   = require ("Pylon.Task")

Clock = require_provider ("Pylon.MonotonicClock")

PackageFile = require ("Carrier.PackageFile")
PublicKey = require ("Carrier.PublicKey")

include ("developer.lua")
include ("packages.lua")
include ("package.lua")
include ("ipackagerelease.lua")
include ("packagerelease.lua")
include ("localdeveloperpackagerelease.lua")
include ("remotedeveloperpackagerelease.lua")

function Carrier.ToFileName (s)
	return string.gsub (string.lower (s), "[^%w%.%-%+_]", "_")
end

local debugColor = Color (192, 192, 192)
function Carrier.Debug (message)
	MsgC (debugColor, "Carrier: " .. message .. "\n")
end

function Carrier.Log (message)
	print ("Carrier: " .. message)
end

local warningColor = Color (255, 192, 64)
function Carrier.Warning (message)
	MsgC (warningColor, "Carrier: Warning: " .. message .. "\n")
end

Carrier.Packages = Carrier.Packages ()

return Carrier
