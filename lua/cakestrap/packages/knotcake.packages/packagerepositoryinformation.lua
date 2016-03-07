local self = {}
Packages.PackageRepositoryInformation = Class (self, ICloneable, ISerializable)

-- Identity
self.Url         = Property (nil, "StringN16")
self.Directory   = Property (nil, "StringN16")

-- Metadata
self.Name        = Property ("",  "StringN8",  true)
self.Description = Property ("",  "StringN32", true)
self.ReleasesUrl = Property ("",  "StringN32", true)

function self:ctor ()
end
