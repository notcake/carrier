local self = {}
Packages.PackageRelease = Class (self, Packages.PackageReleaseInformation)

self.Zombie = Property (false, "Boolean")

function self:ctor (package, autosaver)
	self.Package   = package
	self.Autosaver = autosaver
end

-- PackageRelease
-- Parent
function self:GetPackage ()
	return self.Package
end

function self:Update (releaseTable)
	self:FromTable (releaseTable)
end
