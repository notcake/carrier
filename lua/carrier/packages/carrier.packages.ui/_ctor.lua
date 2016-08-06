UI = {}

Concurrency = Carrier.LoadPackage ("Pylon.Concurrency")
Concurrency.Initialize (_ENV)

Enumeration = Carrier.LoadPackage ("Pylon.Enumeration")
Enumeration.Initialize (_ENV)

Text = Carrier.LoadPackage ("Pylon.Text.GarrysMod")
Util = Carrier.LoadPackage ("Pylon.Util")

Packages = Carrier.LoadPackage ("Carrier.Packages")

include ("apt-sources.lua")
include ("apt-get.lua")

function UI.RegisterCommands (packageManager)
	UI.AptSources.RegisterCommand (packageManager)
	UI.AptGet.RegisterCommand (packageManager)
end

function UI.UnregisterCommands (packageManager)
	UI.AptSources.UnregisterCommand (packageManager)
	UI.AptGet.UnregisterCommand (packageManager)
end

return UI
