if Carrier and
   type (Carrier.Uninitialize) == "function" then
	Carrier.Uninitialize ()
end

Carrier = {}

local packages        = {}
local orderedPackages = {} -- Package names ordered by load completion times

function Carrier.Package(name)
	local package =
	{
		Name = name,
		Dependencies = {},
		Environment = {},
		Exports = nil
	}
	
	package.Environment._ENV = package.Environment
	
	setmetatable (
		package.Environment,
		{
			__index = function (t, key)
				return _G [key]
			end,
		}
	)
	
	return package
end

local sv_allowcslua = GetConVar ("sv_allowcslua")

-- Package existence cache
Carrier.PackageCache = {}
function Carrier.InvalidatePackageCache ()
	if not next (Carrier.PackageCache) then return end
	Carrier.PackageCache = {}
end

function Carrier.RebuildPackageCache (pathId)
	Carrier.PackageCache [pathId] = {}
	Carrier.PackageCache [pathId].Files       = {}
	Carrier.PackageCache [pathId].Directories = {}
	
	local files, folders = file.Find ("carrier/packages/*", pathId)
	for _, file in ipairs (files) do
		Carrier.PackageCache [pathId].Files [string.lower (file)] = true
	end
	for _, folder in ipairs (folders) do
		Carrier.PackageCache [pathId].Directories [string.lower (folder)] = true
	end
end

function Carrier.PackageEntityExists (entityType, fileName, pathId)
	if not Carrier.PackageCache [pathId] then
		Carrier.RebuildPackageCache (pathId)
	end
	
	return Carrier.PackageCache [pathId] [entityType] [fileName] ~= nil
end

function Carrier.PackageFileExists (fileName, pathId)
	return Carrier.PackageEntityExists ("Files", fileName, pathId)
end

function Carrier.PackageDirectoryExists (fileName, pathId)
	return Carrier.PackageEntityExists ("Directories", fileName, pathId)
end

function Carrier.LuaEntityExists (oracle, name)
	if oracle (name, "LUA") then return true end
	if sv_allowcslua:GetBool () then
		return oracle (name, "LCL")
	else
		return false
	end
end

function Carrier.LuaFileFind (path)
	local resultSet = {}
	
	for _, v in ipairs (file.Find (path, "LUA")) do
		resultSet [v] = true
	end
	if sv_allowcslua:GetBool () then
		for _, v in ipairs (file.Find (path, "LCL")) do
			resultSet [v] = true
		end
	end
	
	return resultSet
end

function Carrier.Warning (message)
	print ("Carrier: Warning: " .. message)
end

function Carrier.LoadPackage (packageName)
	if packages [packageName] then
		return packages [packageName].Exports
	end
	
	local t0 = SysTime ()
	
	-- Resolve ctor
	local fileName = string.lower (packageName)
	local ctorPath1 = "carrier/packages/" .. fileName .. ".lua"
	local ctorPath2 = "carrier/packages/" .. fileName .. "/_ctor.lua"
	local dtorPath1 = nil
	local dtorPath2 = "carrier/packages/" .. fileName .. "/_dtor.lua"
	local ctorPath1Exists = Carrier.LuaEntityExists (Carrier.PackageFileExists,      fileName .. ".lua")
	local ctorPath2Exists = Carrier.LuaEntityExists (Carrier.PackageDirectoryExists, fileName)
	
	local includePath = nil
	local ctorPath    = nil
	local dtorPath    = nil
	if ctorPath1Exists and ctorPath2Exists then
		Carrier.Warning ("Package " .. packageName .. " has both a loadable file and a directory.")
	elseif not ctorPath1Exists and not ctorPath2Exists then
		Carrier.Warning ("Package " .. packageName .. " has no loadable file or directory.")
		return nil
	end
	
	if ctorPath1Exists then
		includePath = "carrier/packages/"
		ctorPath    = ctorPath1
		dtorPath    = dtorPath1
	elseif ctorPath2Exists then
		includePath = "carrier/packages/" .. fileName .. "/"
		ctorPath    = ctorPath2
		dtorPath    = dtorPath2
	end
	
	-- Register package
	local package = Carrier.Package (packageName)
	packages [packageName] = package
	package.Environment.include = function (path)
		path = includePath .. path
		local t0 = SysTime ()
		local f = CompileFile (path)
		local dt = SysTime () - t0
		print (string.format ("Carrier.LoadPackage : CompileFile %s took %.2f ms", path, dt * 1000))
		if not f then
			Carrier.Warning (path .. " not found or has syntax error.")
			return
		end
		setfenv (f, package.Environment)
		return f ()
	end
	package.Environment.require = function (packageName)
		package.Dependencies [packageName] = true
		return Carrier.LoadPackage (packageName)
	end
	package.Environment.require_provider = function (packageName)
		local packageName = packageName .. ".GarrysMod"
		package.Dependencies [packageName] = true
		return Carrier.LoadPackage (packageName)
	end
	
	-- ctor
	local f = CompileFile (ctorPath)
	if f then
		setfenv (f, package.Environment)
		package.Exports = f ()
	else
		Carrier.Warning (ctorPath .. " not found or has syntax error.")
		return
	end
	
	-- dtor
	if dtorPath and
	   Carrier.LuaEntityExists (file.Exists, dtorPath) then
		local f = CompileFile (dtorPath)
		if f then
			setfenv (f, package.Environment)
			package.Destructor = f
		end
	end
	
	orderedPackages [#orderedPackages + 1] = packageName
	
	local dt = SysTime () - t0
	print (string.format ("Carrier.LoadPackage : %s took %.2f ms", packageName, dt * 1000))
	
	return package.Exports
end

function Carrier.UnloadPackage (packageName)
	if not packages [packageName] then return end
	
	print ("Carrier.UnloadPackage : " .. packageName)
	
	if packages [packageName].Destructor then
		packages [packageName].Destructor ()
	end
end

function Carrier.Reload ()
	include ("carrier/bootstrap.lua")
end

function Carrier.Initialize ()
	hook.Add ("OnReloaded", "Carrier", Carrier.InvalidatePackageCache)
	hook.Add ("ShutDown", "Carrier",   Carrier.Uninitialize)
	
	local t0 = SysTime ()
	Carrier.Packages = Carrier.LoadPackage ("Carrier.Packages")
	Carrier.Packages.UI = Carrier.LoadPackage ("Carrier.Packages.UI")

	Carrier.PackageManager = Carrier.Packages.PackageManager ()
	Carrier.Packages.UI.RegisterCommands (Carrier.PackageManager)
	
	for autoload in pairs (Carrier.LuaFileFind ("carrier/autoload/*.lua")) do
		local f = CompileFile ("carrier/autoload/" .. autoload)
		if f then
			setfenv (f, {})
			
			for _, packageName in ipairs ({ f () }) do
				Carrier.LoadPackage (packageName)
			end
		end
	end
	local dt = SysTime () - t0
	print (string.format ("Carrier.Initialize took %.2f ms", dt * 1000))
end

function Carrier.Uninitialize ()
	if Carrier.PackageManager then
		Carrier.PackageManager:dtor ()
		Carrier.PackageManager = nil
	end
	
	for i = #orderedPackages, 1, -1 do
		Carrier.UnloadPackage (orderedPackages [i])
	end
	
	hook.Remove ("OnReloaded", "Carrier")
	hook.Remove ("ShutDown",   "Carrier")
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
