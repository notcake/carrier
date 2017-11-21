-- PACKAGE Carrier

Carrier = {}

Error = require ("Pylon.Error")
OOP   = require ("Pylon.OOP")
OOP.Initialize (_ENV)

IO = require ("Pylon.IO")

Enumeration = require ("Pylon.Enumeration")
Enumeration.Initialize (_ENV)

Async = require_provider ("Pylon.Async")
HTTP  = require_provider ("Pylon.HTTP")
Task  = require ("Pylon.Task")

include ("packages.lua")
include ("package.lua")
include ("packagerelease.lua")
include ("publickey.lua")

Carrier.Packages = Carrier.Packages ()

return Carrier
