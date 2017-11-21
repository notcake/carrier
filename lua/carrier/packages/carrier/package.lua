local self = {}
Carrier.Package = Class (self)

function Carrier.Package.FromJson (info)
	local name = info.name
	local package = Carrier.Package (name)
	return package:FromJson (info)
end

function self:ctor (name)
	self.Name         = name
	
	self.Releases     = {}
	self.ReleaseCount = 0
end

function self:GetName ()
	return self.Name
end

function self:AddRelease (packageRelease)
	if self.Releases [packageRelease:GetVersion ()] then return end
	
	self.Releases [packageRelease:GetVersion ()] = packageRelease
	self.ReleaseCount = self.ReleaseCount + 1
end

function self:GetRelease (version)
	return self.Releases [version]
end

function self:GetReleaseCount ()
	return self.ReleaseCount
end

function self:GetReleaseEnumerator ()
	return self.ValueEnumerator (self.Releases)
end

function self:FromJson (info)
	return self
end
