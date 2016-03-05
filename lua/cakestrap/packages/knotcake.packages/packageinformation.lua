local self = {}
Packages.PackageInformation = Class (self, ICloneable, ISerializable)

self.Name             = Property (nil, "StringN8")
self.DisplayName      = Property (nil, "StringN8")
self.Description      = Property (nil, "StringN32")

self.Size             = Property (nil, "UInt64")

self.VersionTimestamp = Property (nil, "UInt64")
self.Version          = Property (nil, "StringN8")

self.Public           = Property (false, "Boolean")

self.ContentUrl       = Property (nil, "StringN16")
self.HashUrl          = Property (nil, "StringN16")

function self:ctor (packageRepository)
	self.PackageRepository = packageRepository
end

function self:GetPackageRepository ()
	return self.PackageRepository
end

function self:ToPackageReference ()
	local repositoryUrl = self.PackageRepository and self.PackageRepository:GetUrl ()
	return Packages.PackageReference (repositoryUrl, self.PackageName, self.VersionTimestamp)
end
