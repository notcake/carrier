-- PACKAGE Carrier.PackageFile

Error = require ("Pylon.Error")
OOP   = require ("Pylon.OOP")
OOP.Initialize (_ENV)

IO = require ("Pylon.IO")

Enumeration = require ("Pylon.Enumeration")
Enumeration.Initialize (_ENV)

Verification = require ("Panopticon.Verification")

include ("packagefile.lua")
include ("isection.lua")
include ("unknownsection.lua")
include ("dependenciessection.lua")
include ("filesystemsection.lua")
include ("filesystemfile.lua")
include ("luahashessection.lua")
include ("signaturesection.lua")

return PackageFile
