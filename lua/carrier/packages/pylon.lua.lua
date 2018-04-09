-- PACKAGE Pylon.Lua

local Lua = {}

function Lua.WithoutDebugHook (f, ...)
	local hook = { debug.gethook () }
	debug.sethook ()
	
	return (
		function (success, ...)
			debug.sethook (unpack (hook))
			
			if success then
				return ...
			else
				error (...)
			end
		end
	) (pcall (f, ...))
end

return Lua
