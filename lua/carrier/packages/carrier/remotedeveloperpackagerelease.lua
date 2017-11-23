local self = {}
Carrier.RemoteDeveloperPackageRelease = Class (self, Carrier.IPackageRelease)

function self:ctor (name, timestamp)
	self.Name            = name
	self.Version         = "dev-remote-" .. string.format ("%08x", timestamp)
	self.Timestamp       = timestamp
	
	self.Dependencies    = {}
	self.DependencyCount = 0
	
	self.Size            = nil
	self.FileName        = "dev-remote-" .. Carrier.ToFileName (self.Name) .. "-" .. string.format ("%08x", self.Timestamp)
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

-- Dependents
function self:GetDependentCount ()
	return self.DependentCount
end

function self:GetDependentEnumerator ()
	return KeyValueEnumerator (self.Dependents)
end

-- RemoteDeveloperPackageRelease
function self:IsLocal ()
	return false
end

function self:IsRemote ()
	return true
end

function self:GetSize ()
	return self
end
