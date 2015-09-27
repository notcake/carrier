local self = {}
CakeStrap.PackageRepositoryInformation = CakeStrap.Class (self, CakeStrap.ICloneable, CakeStrap.ISerializable)

self.Url         = CakeStrap.Property (nil, "StringN16")

self.Name        = CakeStrap.Property (nil, "StringN8")
self.Description = CakeStrap.Property (nil, "StringN32")

function self:ctor ()
end
