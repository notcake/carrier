UI = {}

Concurrency = CakeStrap.LoadPackage ("Knotcake.Concurrency")
Concurrency.Initialize (_ENV)

Enumeration = CakeStrap.LoadPackage ("Knotcake.Enumeration")
Enumeration.Initialize (_ENV)

Text = CakeStrap.LoadPackage ("Knotcake.Text.GarrysMod")
Util = CakeStrap.LoadPackage ("Knotcake.Util")

Packages = CakeStrap.LoadPackage ("Knotcake.Packages")

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
