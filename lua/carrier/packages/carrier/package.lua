local self = {}
Carrier.Package = Class(self, ISerializable)

function Carrier.Package.FromJson(info)
	local name = info.name
	local package = Carrier.Package(name)
	return package:FromJson(info)
end

function self:ctor(name)
	self.Name                  = name
	
	self.LocalDeveloperRelease = nil
	self.Releases              = {}
	self.ReleaseCount          = 0
	self.DeveloperReleaseCount = 0
	
	self.Loaded                = false
	self.LoadedRelease         = nil
	self.LoadEnvironment       = nil
	self.LoadExports           = nil
	self.LoadDestructor        = nil
end

-- ISerializable
function self:Serialize(streamWriter)
	streamWriter:UInt32(self.ReleaseCount - self.DeveloperReleaseCount)
	for packageRelease in self:GetReleaseEnumerator() do
		if not packageRelease:IsDeveloper() then
			streamWriter:StringN8(packageRelease:GetVersion())
			packageRelease:Serialize(streamWriter)
		end
	end
end

function self:Deserialize(streamReader)
	local releaseCount = streamReader:UInt32()
	for i = 1, releaseCount do
		local packageReleaseVersion = streamReader:StringN8()
		local packageRelease = self:GetRelease(packageReleaseVersion) or Carrier.PackageRelease(self.Name, packageReleaseVersion)
		packageRelease:Deserialize(streamReader)
		self:AddRelease(packageRelease)
	end
end

-- Package
function self:GetName()
	return self.Name
end

function self:AddRelease(packageRelease)
	if self.Releases[packageRelease:GetVersion()] then return end
	
	self.Releases[packageRelease:GetVersion()] = packageRelease
	self.ReleaseCount = self.ReleaseCount + 1
	if packageRelease:IsDeveloper() then
		self.DeveloperReleaseCount = self.DeveloperReleaseCount + 1
		if packageRelease:IsLocal() then
			self.LocalDeveloperRelease = packageRelease
		end
	end
end

function self:RemoveRelease(packageRelease)
	if not packageRelease then return end
	local packageReleaseVersion = type(packageRelease) == "string" and packageRelease or packageRelease:GetVersion()
	
	local packageRelease = self.Releases[packageReleaseVersion]
	if not packageRelease then return end
	
	self.Releases[packageReleaseVersion] = nil
	self.ReleaseCount = self.ReleaseCount - 1
	if packageRelease:IsDeveloper() then
		self.DeveloperReleaseCount = self.DeveloperReleaseCount - 1
		if self.LocalDeveloperRelease == packageRelease then
			self.LocalDeveloperRelease = nil
		end
	end
end

function self:GetLatestRelease()
	local latestPackageRelease = nil
	for packageRelease in self:GetReleaseEnumerator() do
		if not packageRelease:IsDeveloper() and
		   not packageRelease:IsDeprecated() then
			if not latestPackageRelease or
			   latestPackageRelease:GetTimestamp() < packageRelease:GetTimestamp() then
				latestPackageRelease = packageRelease
			end
		end
	end
	return latestPackageRelease
end

function self:GetLocalDeveloperRelease()
	return self.LocalDeveloperRelease
end

function self:GetRelease(packageReleaseVersion)
	return self.Releases[packageReleaseVersion]
end

function self:GetReleaseCount()
	return self.ReleaseCount
end

function self:GetReleaseEnumerator()
	return ValueEnumerator(self.Releases)
end

-- Loading
function self:Assimilate(packageRelease, environment, exports, destructor)
	self.Loaded          = true
	self.LoadedRelease   = packageRelease
	self.LoadEnvironment = environment
	self.LoadExports     = exports
	self.LoadDestructor  = destructor
	
	Carrier.Debug("Assimilated package " .. self.Name .. ".")
end

function self:AssimilateInto(packages, package)
	if not self:IsLoaded() then return end
	
	local packageRelease = package:GetRelease(self:GetLoadedRelease():GetVersion())
	if not packageRelease then
		Carrier.Warning("Cannot transfer package " .. self.Name .. ", since release " .. self:GetLoadedRelease():GetVersion() .. " is missing from new package system.")
	end
	
	packages:Assimilate(package, packageRelease, self.LoadEnvironment, self.LoadExports, self.LoadDestructor)
end

function self:GetLoadedRelease()
	return self.LoadedRelease
end

function self:IsLoaded()
	return self.Loaded
end

function self:Load(packageReleaseVersion)
	if self.Loaded then return self.LoadExports end
	
	local t0 = Clock()
	local packageRelease = self:GetRelease(packageReleaseVersion)
	if not packageRelease then
		Carrier.Warning("Load: " .. self.Name .. " " .. packageReleaseVersion .. " not found!")
		return nil
	end
	
	self.Loaded = true
	self.LoadedRelease = packageRelease
	self.LoadEnvironment = {}
	self.LoadEnvironment._ENV = self.LoadEnvironment
	setmetatable(self.LoadEnvironment, { __index = getfenv() })
	self.LoadEnvironment.require = function(packageName)
		return Carrier.Packages:Load(packageName)
	end
	self.LoadEnvironment.require_provider = function(packageName)
		return Carrier.Packages:LoadProvider(packageName)
	end
	self.LoadEnvironment.include = function(path)
		local f = self.LoadEnvironment.loadfile(path)
		if not f then return end
		return f()
	end
	
	self.LoadExports, self.LoadDestructor = packageRelease:Load(self.LoadEnvironment)
	
	local dt = Clock () - t0
	if dt > 0.1 then
		Carrier.Log(string.format("Load: %s %s took %.2f ms!", self.Name, packageReleaseVersion, dt * 1000))
	else
		Carrier.Debug(string.format("Load: %s %s took %.2f ms", self.Name, packageReleaseVersion, dt * 1000))
	end

	return self.LoadExports
end

function self:Unload()
	if not self.Loaded then return end
	
	Carrier.Log("Unload: " .. self.Name)
	
	if self.LoadDestructor then
		local success, err = xpcall(self.LoadDestructor, debug.traceback)
		if not success then Carrier.Warning(err) end
	end
	
	self.Loaded          = false
	self.LoadedRelease   = nil
	self.LoadEnvironment = nil
	self.LoadExports     = nil
	self.LoadDestructor  = nil
end

function self:FromJson(info)
	return self
end
