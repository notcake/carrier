local self = {}
Carrier.PackageRelease = Class (self)

function self:ctor (version)
	self.Version = version
	
	self.Dependencies    = {}
	self.DependencyCount = 0
end
