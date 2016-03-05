UI = {}

Concurrency = CakeStrap.LoadPackage ("Knotcake.Concurrency")
Concurrency.Initialize (_ENV)

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
