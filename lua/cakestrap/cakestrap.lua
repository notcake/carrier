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

CakeStrap.OOP          = CakeStrap.LoadPackage ("Knotcake.OOP")
CakeStrap.OOP.Initialize (CakeStrap)
CakeStrap.Crypto       = CakeStrap.LoadPackage ("Knotcake.Crypto")
CakeStrap.IO           = CakeStrap.LoadPackage ("Knotcake.IO")
CakeStrap.IO.GarrysMod = CakeStrap.LoadPackage ("Knotcake.IO.GarrysMod")

include ("packagerepositoryinformation.lua")
include ("packageinformation.lua")
include ("packagereference.lua")

include ("packagerepository.lua")
include ("package.lua")
include ("packagemanager.lua")

CakeStrap.PackageManager = CakeStrap.PackageManager ()
CakeStrap.PackageManager:AddPackageRepositoryFromUrl ("https://packages.knotcake.net")

function CakeStrap.Reload ()
	include ("autorun/cakestrap.lua")
end

if SERVER then
	concommand.Add ("cakestrap_reload",
		function (ply)
			if ply:IsValid () and not ply:IsAdmin () then return end
			
			CakeStrap.Reload ()
		end
	)
	
	concommand.Add ("cakestrap_reload_sv",
		function (ply)
			if ply:IsValid () and not ply:IsAdmin () then return end
			
			CakeStrap.Reload ()
		end
	)
elseif CLIENT then
	concommand.Add ("cakestrap_reload",    CakeStrap.Reload)
	concommand.Add ("cakestrap_reload_cl", CakeStrap.Reload)
end
