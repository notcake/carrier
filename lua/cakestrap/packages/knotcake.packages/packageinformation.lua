local self = {}
Packages.PackageInformation = Class (self, ICloneable, ISerializable)

function Packages.PackageInformation.FromTable (t, out)
	out = out or Packages.PackageInformation ()
	
	return out:FromTable (t)
end

self.Id          = Property (nil, "UInt64")

self.Name        = Property (nil, "StringN8")
self.DisplayName = Property (nil, "StringN8",  true)
self.Description = Property (nil, "StringN32", true)

function self:ctor ()
end

function self:FromTable (source)
	self.Id          = source.id
	
	self.Name        = source.name
	self.DisplayName = source.displayName
	
	self.Description = source.description
	
	return self
end

function self:ToPackageReference (repositoryUrl)
	return Packages.PackageReference (repositoryUrl, self.PackageName, self.VersionTimestamp)
end
