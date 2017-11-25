local self = {}
Carrier.IPackageRelease = Interface (self)

function self:ctor (name)
	self.Name = name
	
	self.Dependencies    = {}
	self.DependencyCount = 0
	
	self.Dependents      = {}
	self.DependentCount  = 0
end

function self:GetName ()
	return self.Name
end

function self:GetVersion ()
	Error ("IPackageRelease:GetVersion : Not implemented.")
end

function self:GetTimestamp ()
	Error ("IPackageRelease:GetTimestamp : Not implemented.")
end

function self:IsDeprecated ()
	Error ("IPackageRelease:IsDeprecated : Not implemented.")
end

function self:IsDeveloper ()
	Error ("IPackageRelease:IsDeveloper : Not implemented.")
end

-- Dependencies
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

function self:RemoveDependency (name)
	if not self.Dependencies [name] then return end
	
	self.Dependencies [name] = nil
	self.DependencyCount = self.DependencyCount - 1
end

-- Dependents
function self:AddDependent (name, version)
	if not self.Dependents [name] then
		self.DependentCount = self.DependentCount + 1
	end
	self.Dependents [name] = version
end

function self:GetDependentCount ()
	return self.DependentCount
end

function self:GetDependentEnumerator ()
	return KeyValueEnumerator (self.Dependents)
end

function self:RemoveDependent (name)
	if not self.Dependents [name] then return end
	
	self.Dependents [name] = nil
	self.DependentCount = self.DependentCount - 1
end

-- Loading
function self:IsAvailable ()
	Error ("IPackageRelease:IsAvailable : Not implemented.")
end

function self:Load (environment)
	Error ("IPackageRelease:Load : Not implemented.")
end
