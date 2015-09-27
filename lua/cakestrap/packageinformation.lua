local self = {}
CakeStrap.PackageInformation = CakeStrap.Class (self, CakeStrap.ICloneable, CakeStrap.ISerializable)

self.Name             = CakeStrap.Property (nil, "StringN8")
self.DisplayName      = CakeStrap.Property (nil, "StringN8")
self.Description      = CakeStrap.Property (nil, "StringN32")

self.Size             = CakeStrap.Property (nil, "UInt64")

self.VersionTimestamp = CakeStrap.Property (nil, "UInt64")
self.Version          = CakeStrap.Property (nil, "StringN8")

self.Public           = CakeStrap.Property (false, "Boolean")

self.ContentUrl       = CakeStrap.Property (nil, "StringN16")
self.HashUrl          = CakeStrap.Property (nil, "StringN16")

function self:ctor (packageRepository)
	self.PackageRepository = packageRepository
end

function self:GetPackageRepository ()
	return self.PackageRepository
end

function self:ToPackageReference ()
	local repositoryUrl = self.PackageRepository and self.PackageRepository:GetUrl ()
	return CakeStrap.PackageReference (repositoryUrl, self.PackageName, self.VersionTimestamp)
end
