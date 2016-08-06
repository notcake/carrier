Packages = {}

Error = Carrier.LoadPackage ("Pylon.Error")
OOP   = Carrier.LoadPackage ("Pylon.OOP")
OOP.Initialize (_ENV)

IO = {}
Carrier.LoadProvider ("Pylon.IO").Initialize (IO)

Enumeration = Carrier.LoadPackage ("Pylon.Enumeration")
Enumeration.Initialize (_ENV)

HTTP = Carrier.LoadProvider ("Pylon.HTTP")

Text = Carrier.LoadPackage ("Pylon.Text")
Util = Carrier.LoadPackage ("Pylon.Util")

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
