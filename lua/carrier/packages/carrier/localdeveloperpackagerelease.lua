local self = {}
Carrier.LocalDeveloperPackageRelease = Class (self, Carrier.IPackageRelease)

function self:ctor (name, basePath, constructorPath, destructorPath, pathId)
	self.Timestamp       = file.Time (basePath, pathId)
	self.Version         = "dev-local-" .. string.format ("%08x", self.Timestamp)
	
	self.FileName        = "dev-local-" .. Carrier.ToFileName (self.Name) .. "-" .. string.format ("%08x", self.Timestamp) .. ".dat"
	
	self.PathId          = pathId
	self.BasePath        = basePath
	self.ConstructorPath = constructorPath
	self.DestructorPath  = destructorPath
end

-- IPackageRelease
function self:GetVersion ()
	return self.Version
end

function self:GetTimestamp ()
	return self.Timestamp
end

function self:IsDeprecated ()
	return false
end

function self:IsDeveloper ()
	return true
end

-- Loading
function self:IsAvailable ()
	return true
end

function self:Load (environment)
	environment.loadfile = function (path)
		path = self.BasePath .. "/" .. path
		
		local f = CompileFile (path)
		
		if not f then
			Carrier.Warning (path .. " not found or has syntax error.")
			return nil, nil
		end
		
		setfenv (f, environment)
		return f
	end
	
	-- ctor
	local f = CompileFile (self.ConstructorPath)
	if not f then
		Carrier.Warning (self.ConstructorPath .. " not found or has syntax error.")
		return nil, nil
	end
	
	setfenv (f, environment)
	
	-- dtor
	local destructor = self.DestructorPath and CompileFile (self.DestructorPath)
	if destructor then
		setfenv (destructor, environment)
	end
	
	local success, exports = xpcall (f, debug.traceback)
	if not success then
		Carrier.Warning (exports)
		return nil, destructor
	end
	
	return exports, destructor
end

-- LocalDeveloperPackageRelease
function self:IsLocal ()
	return true
end

function self:IsRemote ()
	return false
end
