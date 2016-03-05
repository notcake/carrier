if CakeStrap then
	CakeStrap.Unload ()
end

CakeStrap = {}

local packageEnvironments = {}
local packages            = {}

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
	packageEnvironments [packageName]._ENV = packageEnvironments [packageName]
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

function CakeStrap.LoadProvider (serviceName)
	return CakeStrap.LoadPackage (serviceName .. ".GarrysMod")
end

function CakeStrap.UnloadPackage (packageName)
	if not packageEnvironments [packageName] then return end
	
	local fileName = string.lower (packageName)
	local dtorPath = "cakestrap/packages/" .. fileName .. "/_dtor.lua"
	if not CakeStrap.LuaFileExists (dtorPath) then return end
	
	local f = CompileFile (dtorPath)
	
	setfenv (f, packageEnvironments [packageName])
	f ()
end

function CakeStrap.Unload ()
	for packageName, _ in pairs (packageEnvironments) do
		CakeStrap.UnloadPackage (packageName)
	end
end

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

CakeStrap.Packages = CakeStrap.LoadPackage ("Knotcake.Packages")
CakeStrap.Packages.UI = CakeStrap.LoadPackage ("Knotcake.Packages.UI")

CakeStrap.PackageManager = CakeStrap.Packages.PackageManager ()
CakeStrap.PackageManager:Load ()
CakeStrap.Packages.UI.RegisterCommands (CakeStrap.PackageManager)
