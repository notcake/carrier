local self = {}
Carrier.PackageRelease = Class (self, Carrier.IPackageRelease, ISerializable)

function Carrier.PackageRelease.FromJson (info, name)
	local version = info.version
	local packageRelease = Carrier.PackageRelease (name, version)
	return packageRelease:FromJson (info)
end

function self:ctor (name, version)
	self.Name            = name
	self.Version         = version
	self.Timestamp       = 0
	
	self.Deprecated      = false
	
	self.Dependencies    = {}
	self.DependencyCount = 0
	
	self.Dependents      = {}
	self.DependentCount  = 0
	
	self.Size            = 0
	self.FileName        = nil
end

-- ISerializable
function self:Serialize (streamWriter)
	streamWriter:UInt64  (self.Timestamp)
	streamWriter:Boolean (self.Deprecated)
	streamWriter:UInt64  (self.Size)
	
	streamWriter:UInt32 (self.DependencyCount)
	for dependencyName, dependencyVersion in self:GetDependencyEnumerator () do
		streamWriter:StringN8 (dependencyName)
		streamWriter:StringN8 (dependencyVersion)
	end
end

function self:Deserialize (streamReader)
	self.Timestamp  = streamReader:UInt64  ()
	self.Deprecated = streamReader:Boolean ()
	self.Size       = streamReader:UInt64  ()
	
	local dependencyCount = streamReader:UInt32 ()
	for i = 1, dependencyCount do
		local dependencyName    = streamReader:StringN8 ()
		local dependencyVersion = streamReader:StringN8 ()
		self:AddDependency (dependencyName, dependencyVersion)
	end
	
	self:UpdateFileName ()
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
	return self.Deprecated
end

function self:IsDeveloper ()
	return false
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

-- PackageRelease
function self:GetSize ()
	return self.Size
end

function self:GetFileName ()
	return self.FileName
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

function self:FromJson (info)
	self.Timestamp = info.timestamp
	self.Size      = info.size
	
	for dependencyName, dependencyVersion in pairs (info.dependencies) do
		self:AddDependency (dependencyName, dependencyVersion)
	end
	
	self:UpdateFileName ()
	
	return self
end

-- Internal
function self:UpdateFileName ()
	self.FileName = "release-" .. Carrier.ToFileName (self.Name) .. "-" .. string.format ("%08x", self.Timestamp) .. "-" .. Carrier.ToFileName (self.Version) .. ".dat"
end
