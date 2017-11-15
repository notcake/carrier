-- PACKAGE Carrier.PackageFile

Error = require ("Pylon.Error")
OOP   = require ("Pylon.OOP")
OOP.Initialize (_ENV)

IO = {}
require_provider ("Pylon.IO").Initialize (IO)

Enumeration = require ("Pylon.Enumeration")
Enumeration.Initialize (_ENV)

include ("packagefile.lua")
include ("section.lua")
include ("unknownsection.lua")
include ("dependenciessection.lua")
include ("filesystemsection.lua")
include ("filesystemfile.lua")

return PackageFile
