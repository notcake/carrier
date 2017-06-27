UI = {}

Task = require ("Pylon.Task")

Enumeration = require ("Pylon.Enumeration")
Enumeration.Initialize (_ENV)

Text = require ("Pylon.Text.GarrysMod")
Util = require ("Pylon.Util")

Packages = require ("Carrier.Packages")

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
