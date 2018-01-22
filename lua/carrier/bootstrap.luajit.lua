if Carrier and
   type (Carrier.Uninitialize) == "function" then
	Carrier.Uninitialize ()
end

Carrier = {}

local packages        = {}
local orderedPackages = {} -- Package names ordered by load completion times

function Carrier.Package (name)
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
			__index = getfenv ()
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
	local fileName = string.lower (packageName)
	local ctorPath1 = "carrier/packages/" .. fileName .. ".lua"
	local ctorPath2 = "carrier/packages/" .. fileName .. "/_ctor.lua"
	local dtorPath1 = nil
	local dtorPath2 = "carrier/packages/" .. fileName .. "/_dtor.lua"
	local ctorPath1Exists = loadfile (ctorPath1) ~= nil
	local ctorPath2Exists = loadfile (ctorPath2) ~= nil
	
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
		package.Dependencies [packageName] = true
		return Carrier.LoadPackage (packageName)
	end
	package.Environment.require_provider = function (packageName)
		local packageName = packageName .. ".LuaJIT"
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

Carrier.Require = Carrier.LoadPackage
Carrier.require = Carrier.LoadPackage

function Carrier.UnloadPackage (packageName)
	if not packages [packageName] then return end
	
	if packages [packageName].Destructor then
		packages [packageName].Destructor ()
	end
end

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
