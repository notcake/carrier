local self = {}
Packages.PackageRepository.ManifestSerializer = Class (self, ISerializer)

function self:ctor ()
end

-- ISerializer
function self:Serialize (streamWriter, object)
end

function self:Deserialize (streamReader, object)
end
