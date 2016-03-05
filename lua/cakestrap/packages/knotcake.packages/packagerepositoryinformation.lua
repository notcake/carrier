local self = {}
Packages.PackageRepositoryInformation = Class (self, ICloneable, ISerializable)

-- Identity
self.Url         = Property (nil, "StringN16")
self.Directory   = Property (nil, "StringN16")

-- Metadata
self.Name        = Property (nil, "StringN8")
self.Description = Property (nil, "StringN32")

function self:ctor ()
end
