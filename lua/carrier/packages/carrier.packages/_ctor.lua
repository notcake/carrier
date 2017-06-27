Packages = {}

Error = require ("Pylon.Error")
OOP   = require ("Pylon.OOP")
OOP.Initialize (_ENV)

IO = {}
require_provider ("Pylon.IO").Initialize (IO)

Enumeration = require ("Pylon.Enumeration")
Enumeration.Initialize (_ENV)

HTTP = require_provider ("Pylon.HTTP")

Text = require ("Pylon.Text")
Util = require ("Pylon.Util")

include ("packagerepositoryinformation.lua")
include ("packageinformation.lua")
include ("packagereleaseinformation.lua")
include ("packagereference.lua")

include ("packagemanager.lua")
include ("packagemanager.repositorylistserializer.lua")
include ("packagerepository.lua")
include ("packagerepository.metadataserializer.lua")
include ("packagerepository.manifestserializer.lua")
include ("package.lua")
include ("packagerelease.lua")

return Packages
