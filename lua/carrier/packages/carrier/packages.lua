local self = {}
Carrier.Packages = Class (self)

function self:ctor ()
	self.Packages     = {}
	self.PackageCount = 0
end

function self:Update ()
	local url = "https://garrysmod.io/api/packages/v1/packages"
end
