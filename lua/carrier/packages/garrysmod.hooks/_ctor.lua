-- PACKAGE GarrysMod.Hooks

local Hooks = {}

Error = require("Pylon.Error")

require("Pylon.OOP").Initialize(_ENV)
require("Pylon.Enumeration").Initialize(_ENV)

include("hooksystem.lua")

HookSystem = HookSystem()

for _, action in ipairs({ "Add", "Remove" }) do
	for _, type in ipairs({ "Pre", "", "Post" }) do
		local methodName = action .. type .. "Hook"
		Hooks[methodName] = function(...)
			HookSystem[methodName](HookSystem, ...)
		end
	end
end

return Hooks
