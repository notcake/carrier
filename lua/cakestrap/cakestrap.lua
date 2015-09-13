CakeStrap = {}

local packageEnvironments = {}
local packages = {}

function CakeStrap.LoadPackage (packageName)
	if packageEnvironments [packageName] then
		return packages [packageName]
	end
	
	local fileName = string.lower (packageName)
	local f = CompileFile ("cakestrap/packages/" .. fileName .. ".lua")
	
	packageEnvironments [packageName] = {}
	packageEnvironments [packageName].include = function (path)
		path = "cakestrap/packages/" .. path
		local f = CompileFile (path)
		setfenv (f, packageEnvironments [packageName])
		local ret = { f () }
		return unpack (ret)
	end
	
	setmetatable (
		packageEnvironments [packageName],
		{
			__index = function (t, key)
				return _G [key]
			end,
		}
	)
	
	setfenv (f, packageEnvironments [packageName])
	packages [packageName] = f ()
	
	return packages [packageName]
end

CakeStrap.OOP = CakeStrap.LoadPackage ("Knotcake.OOP")
CakeStrap.OOP.Initialize (CakeStrap)
CakeStrap.Crypto = CakeStrap.LoadPackage ("Knotcake.Crypto")

include ("package.lua")
