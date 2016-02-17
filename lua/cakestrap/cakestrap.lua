CakeStrap = {}

local packageEnvironments = {}
local packages = {}

local sv_allowcslua = GetConVar ("sv_allowcslua")
function CakeStrap.LuaFileExists (path)
	if file.Exists (path, "LUA") then return true end
	if not sv_allowcslua:GetBool () then return false end
	return file.Exists (path, "LCL")
end

function CakeStrap.Warning (message)
	print ("CakeStrap: Warning: " .. message)
end

function CakeStrap.LoadPackage (packageName)
	if packageEnvironments [packageName] then
		return packages [packageName]
	end
	
	local fileName = string.lower (packageName)
	local ctorPath1 = "cakestrap/packages/" .. fileName .. ".lua"
	local ctorPath2 = "cakestrap/packages/" .. fileName .. "/_ctor.lua"
	local ctorPath1Exists = CakeStrap.LuaFileExists (ctorPath1)
	local ctorPath2Exists = CakeStrap.LuaFileExists (ctorPath2)
	
	local includePath = nil
	local ctorPath    = nil
	if ctorPath1Exists and ctorPath2Exists then
		CakeStrap.Warning ("Package " .. packageName .. " has both a loadable file and a directory.")
	elseif not ctorPath1Exists and not ctorPath2Exists then
		CakeStrap.Warning ("Package " .. packageName .. " has no loadable file or directory.")
		return nil
	end
	
	if ctorPath1Exists then
		includePath = "cakestrap/packages/"
		ctorPath    = ctorPath1
	elseif ctorPath2Exists then
		includePath = "cakestrap/packages/" .. fileName .. "/"
		ctorPath    = ctorPath2
	end
	
	local f = CompileFile (ctorPath)
	
	packageEnvironments [packageName] = {}
	packageEnvironments [packageName].include = function (path)
		path = includePath .. path
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
