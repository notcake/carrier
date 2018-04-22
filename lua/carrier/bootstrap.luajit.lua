if Carrier and
   type (Carrier.Uninitialize) == "function" then
	Carrier.Uninitialize ()
end

Carrier = {}

local packages        = {}
local orderedPackages = {} -- Package names ordered by load completion times

local packagesPath = string.match (debug.getinfo (1).source, "^@(.*)/bootstrap.luajit.lua$") or "carrier"
local packagesPaths =
{
	packagesPath .. "/packages/",
	packagesPath .. "/../../../eka/lua/carrier/packages/"
}

local setfenv = setfenv or function (f, env)
	if debug.getupvalue (f, 1) ~= "_ENV" then return end
	
	debug.setupvalue (f, 1, env)
end
local unpack = unpack or table.unpack

function Carrier.Package (name)
	local package =
	{
		Name = name,
		Dependencies = {},
		Environment = {},
		Exports = nil
	}
	
	package.Environment._ENV = package.Environment
	package.Environment.unpack = unpack
	
	setmetatable (
		package.Environment,
		{
			__index = _ENV or getfenv ()
		}
	)
	
	return package
end

function Carrier.Warning (message)
	io.stderr:write ("Carrier: Warning: " .. message .. "\n")
end

function Carrier.LoadPackage (packageName)
	if packages [packageName] then
		return packages [packageName].Exports
	end
	
	local t0 = os.clock ()
	
	-- Resolve ctor
	local includePath = nil
	local ctorPath    = nil
	local dtorPath    = nil
	
	local fileName = string.lower (packageName)
	for i = 1, #packagesPaths do
		local packagesPath = packagesPaths [i]
		
		local ctorPath1 = packagesPath .. fileName .. ".lua"
		local ctorPath2 = packagesPath .. fileName .. "/_ctor.lua"
		local dtorPath1 = nil
		local dtorPath2 = packagesPath .. fileName .. "/_dtor.lua"
		local ctorPath1Exists = loadfile (ctorPath1) ~= nil
		local ctorPath2Exists = loadfile (ctorPath2) ~= nil
		
		if ctorPath1Exists and ctorPath2Exists then
			Carrier.Warning ("Package " .. packageName .. " has both a loadable file and a directory.")
		end
		
		if ctorPath1Exists then
			includePath = packagesPath
			ctorPath    = ctorPath1
			dtorPath    = dtorPath1
		elseif ctorPath2Exists then
			includePath = packagesPath .. fileName .. "/"
			ctorPath    = ctorPath2
			dtorPath    = dtorPath2
		end
	end
	
	if not ctorPath then
		Carrier.Warning ("Package " .. packageName .. " has no loadable file or directory.")
		return nil
	end
	
	-- Register package
	local package = Carrier.Package (packageName)
	packages [packageName] = package
	package.Environment.include = function (path)
		path = includePath .. path
		local t0 = os.clock ()
		local f = loadfile (path)
		local dt = os.clock () - t0
		if not f then
			Carrier.Warning (path .. " not found or has syntax error.")
			return
		end
		setfenv (f, package.Environment)
		return f ()
	end
	package.Environment.require = function (packageName)
		if packageName == "ffi" then return require ("ffi") end
		
		package.Dependencies [packageName] = true
		return Carrier.LoadPackage (packageName)
	end
	package.Environment.require_provider = function (packageName)
		local packageName = packageName .. (jit and ".LuaJIT" or ".Lua")
		package.Dependencies [packageName] = true
		return Carrier.LoadPackage (packageName)
	end
	
	-- ctor
	local f = loadfile (ctorPath)
	if f then
		setfenv (f, package.Environment)
		package.Exports = f ()
	else
		Carrier.Warning (ctorPath .. " not found or has syntax error.")
		return
	end
	
	-- dtor
	if dtorPath then
		local f = loadfile (dtorPath)
		if f then
			setfenv (f, package.Environment)
			package.Destructor = f
		end
	end
	
	orderedPackages [#orderedPackages + 1] = packageName
	
	return package.Exports
end

function Carrier.UnloadPackage (packageName)
	if not packages [packageName] then return end
	
	if packages [packageName].Destructor then
		packages [packageName].Destructor ()
	end
end

Carrier.Require   = Carrier.LoadPackage
Carrier.Unrequire = Carrier.UnloadPackage
Carrier.Download  = function (packageName) end
Carrier.require   = Carrier.LoadPackage
Carrier.unrequire = Carrier.UnloadPackage

if arg then
	if #arg == 0 then
		print ("Usage: luajit " .. arg [0] .. " <package name>")
	else
		local packageName = arg [1]
		arg [0] = "luajit " .. arg [0] .. " " .. arg [1]
		table.remove (arg, 1)
		local f = Carrier.Require (packageName)
		if type (f) == "function" then
			f (unpack (arg, 0, #arg))
		end
	end
end
