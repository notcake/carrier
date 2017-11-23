local self = {}
Carrier.LocalDeveloperPackageRelease = Class (self, Carrier.IPackageRelease)

function self:ctor (name, timestamp, basePath, constructorPath, destructorPath, pathId)
	self.Name            = name
	self.Version         = "dev-local-" .. string.format ("%08x", timestamp)
	self.Timestamp       = timestamp
	
	self.Dependencies    = {}
	self.DependencyCount = 0
	
	self.Dependents      = {}
	self.DependentCount  = 0
	
	self.FileName        = "dev-local-" .. Carrier.ToFileName (self.Name) .. "-" .. string.format ("%08x", self.Timestamp)
	
	self.PathId          = pathId
	self.BasePath        = basePath
	self.ConstructorPath = constructorPath
	self.DestructorPath  = destructorPath
end

-- IPackageRelease
function self:GetName ()
	return self.Name
end

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

-- Dependencies
function self:GetDependencyCount ()
	return self.DependencyCount
end

function self:GetDependencyEnumerator ()
	return KeyValueEnumerator (self.Dependencies)
end

-- Dependents
function self:GetDependentCount ()
	return self.DependentCount
end

function self:GetDependentEnumerator ()
	return KeyValueEnumerator (self.Dependents)
end

-- Loading
function self:Load (environment)
	environment.include = function (path)
		path = self.BasePath .. "/" .. path
		
		local t0 = Clock ()
		local f = CompileFile (path)
		local dt = SysTime () - t0
		Carrier.Log (string.format ("Carrier.LoadPackage : CompileFile %s took %.2f ms", path, dt * 1000))
		
		if not f then
			Carrier.Warning (path .. " not found or has syntax error.")
			return nil, nil
		end
		
		setfenv (f, environment)
		return f ()
	end
	
	-- ctor
	local f = CompileFile (self.ConstructorPath)
	if not f then
		Carrier.Warning (path .. " not found or has syntax error.")
		return nil, nil
	end
	
	setfenv (f, environment)
	
	-- dtor
	local destructor = nil
	if self.DestructorPath then
		local destructor = CompileFile (self.DestructorPath)
		if destructor then
			setfenv (destructor, environment)
		end
	end
	
	return f (), destructor
end

-- LocalDeveloperPackageRelease
function self:IsLocal ()
	return true
end

function self:IsRemote ()
	return false
end

function self:AddDependency (name, version)
	if not self.Dependencies [name] then
		self.DependencyCount = self.DependencyCount + 1
	end
	self.Dependencies [name] = version
end

function self:AddDependent (name, version)
	if not self.Dependents [name] then
		self.DependentCount = self.DependentCount + 1
	end
	self.Dependents [name] = version
end

function self:RemoveDependency (name)
	if not self.Dependencies [name] then return end
	
	self.Dependencies [name] = nil
	self.DependencyCount = self.DependencyCount - 1
end

function self:RemoveDependent (name)
	if not self.Dependents [name] then return end
	
	self.Dependents [name] = nil
	self.DependentCount = self.DependentCount - 1
end
