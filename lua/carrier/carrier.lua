if Carrier and
   type (Carrier.Uninitialize) == "function" then
	Carrier.Uninitialize ()
end

Carrier = {}

local packageEnvironments = {}
local packages            = {}
local orderedPackages     = {} -- Package names ordered by load completion times

local sv_allowcslua = GetConVar ("sv_allowcslua")
function Carrier.LuaFileExists (path)
	if file.Exists (path, "LUA") then return true end
	if not sv_allowcslua:GetBool () then return false end
	return file.Exists (path, "LCL")
end

function Carrier.Warning (message)
	print ("Carrier: Warning: " .. message)
end

function Carrier.LoadPackage (packageName)
	if packageEnvironments [packageName] then
		return packages [packageName]
	end
	
	local fileName = string.lower (packageName)
	local ctorPath1 = "carrier/packages/" .. fileName .. ".lua"
	local ctorPath2 = "carrier/packages/" .. fileName .. "/_ctor.lua"
	local ctorPath1Exists = Carrier.LuaFileExists (ctorPath1)
	local ctorPath2Exists = Carrier.LuaFileExists (ctorPath2)
	
	local includePath = nil
	local ctorPath    = nil
	if ctorPath1Exists and ctorPath2Exists then
		Carrier.Warning ("Package " .. packageName .. " has both a loadable file and a directory.")
	elseif not ctorPath1Exists and not ctorPath2Exists then
		Carrier.Warning ("Package " .. packageName .. " has no loadable file or directory.")
		return nil
	end
	
	if ctorPath1Exists then
		includePath = "carrier/packages/"
		ctorPath    = ctorPath1
	elseif ctorPath2Exists then
		includePath = "carrier/packages/" .. fileName .. "/"
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
	
	orderedPackages [#orderedPackages + 1] = packageName
	
	return packages [packageName]
end

function Carrier.LoadProvider (serviceName)
	return Carrier.LoadPackage (serviceName .. ".GarrysMod")
end

function Carrier.UnloadPackage (packageName)
	if not packageEnvironments [packageName] then return end
	
	print ("Carrier.UnloadPackage : " .. packageName)
	
	local fileName = string.lower (packageName)
	local dtorPath = "carrier/packages/" .. fileName .. "/_dtor.lua"
	if not Carrier.LuaFileExists (dtorPath) then return end
	
	local f = CompileFile (dtorPath)
	
	setfenv (f, packageEnvironments [packageName])
	f ()
end

function Carrier.Reload ()
	include ("autorun/carrier.lua")
end

function Carrier.Initialize ()
	hook.Add ("ShutDown", "Carrier",
		function ()
			Carrier.Uninitialize ()
		end
	)
	
	Carrier.Packages = Carrier.LoadPackage ("Carrier.Packages")
	Carrier.Packages.UI = Carrier.LoadPackage ("Carrier.Packages.UI")

	Carrier.PackageManager = Carrier.Packages.PackageManager ()
	Carrier.Packages.UI.RegisterCommands (Carrier.PackageManager)
end

function Carrier.Uninitialize ()
	if Carrier.PackageManager then
		Carrier.PackageManager:dtor ()
		Carrier.PackageManager = nil
	end
	
	for i = #orderedPackages, 1, -1 do
		Carrier.UnloadPackage (orderedPackages [i])
	end
	
	hook.Remove ("ShutDown", "Carrier")
end

if SERVER then
	concommand.Add ("carrier_reload",
		function (ply)
			if ply:IsValid () and not ply:IsAdmin () then return end
			
			Carrier.Reload ()
		end
	)
	
	concommand.Add ("carrier_reload_sv",
		function (ply)
			if ply:IsValid () and not ply:IsAdmin () then return end
			
			Carrier.Reload ()
		end
	)
elseif CLIENT then
	concommand.Add ("carrier_reload",    Carrier.Reload)
	concommand.Add ("carrier_reload_cl", Carrier.Reload)
end

Carrier.Initialize ()
