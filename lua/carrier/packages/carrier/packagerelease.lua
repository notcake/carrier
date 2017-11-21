local self = {}
Carrier.PackageRelease = Class (self)

function Carrier.PackageRelease.FromJson (info, name)
	local version = info.version
	local packageRelease = Carrier.PackageRelease (name, version)
	return packageRelease:FromJson (info)
end

function self:ctor (name, version)
	self.Timestamp  = 0
	self.Name       = name
	self.Version    = version
	self.Size       = 0
	
	self.FileName   = nil
	self.Deprecated = false
	
	self.Dependencies    = {}
	self.DependencyCount = 0
end

function self:GetTimestamp ()
	return self.Timestamp
end

function self:GetName ()
	return self.Name
end

function self:GetVersion ()
	return self.Version
end

function self:GetSize ()
	return self.Size
end

function self:GetFileName ()
	return self.FileName
end

function self:IsDeprecated ()
	return self.Deprecated
end

function self:IsTransient ()
	return false
end

function self:AddDependency (name, version)
	if not self.Dependencies [name] then
		self.DependencyCount = self.DependencyCount + 1
	end
	self.Dependencies [name] = version
end

function self:GetDependencyCount ()
	return self.DependencyCount
end

function self:GetDependencyEnumerator ()
	return KeyValueEnumerator (self.Dependencies)
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
	self.FileName = string.gsub (string.lower (self.Name), "[^%w%.%-%+_]", "_") .. "-" .. string.format ("%08x", self.Timestamp) .. "-" .. string.gsub (string.lower (self.Version), "[^%w%.%-%+_]", "_")
end
