local self = {}
Packages.PackageInformation = Class (self, ICloneable, ISerializable)

function Packages.PackageInformation.FromTable (t, out)
	out = out or Packages.PackageInformation ()
	
	return out:FromTable (t)
end

self.Id               = Property (nil, "UInt64")

self.Name             = Property (nil, "StringN8")
self.DisplayName      = Property (nil, "StringN8",  true)
self.Description      = Property (nil, "StringN32", true)

function self:ctor (packageRepository)
	self.PackageRepository = packageRepository
end

function self:FromTable (source)
	self.Id          = source.id
	
	self.Name        = source.name
	self.DisplayName = source.displayName
	
	self.Description = source.description
	
	return self
end

function self:GetPackageRepository ()
	return self.PackageRepository
end

function self:ToPackageReference ()
	local repositoryUrl = self.PackageRepository and self.PackageRepository:GetUrl ()
	return Packages.PackageReference (repositoryUrl, self.PackageName, self.VersionTimestamp)
end
