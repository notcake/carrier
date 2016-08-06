local self = {}
Packages.PackageRepository.ManifestSerializer = Class (self, ISerializer)

function self:ctor ()
end

-- ISerializer
function self:Serialize (streamWriter, object)
	streamWriter:UInt32 (object:GetPackageCount ())
	for package in object:GetPackageEnumerator () do
		streamWriter:StringN8 (package:GetName ())
		package:Serialize (streamWriter)
		
		streamWriter:UInt32 (package:GetReleaseCount ())
		for release in package:GetReleaseEnumerator () do
			streamWriter:UInt64 (release:GetVersionTimestamp ())
			release:Serialize (streamWriter)
		end
	end
end

function self:Deserialize (streamReader, object)
	local packageCount = streamReader:UInt32 ()
	for i = 1, packageCount do
		local name = streamReader:StringN8 ()
		local package = object:AddPackage (name)
		package:Deserialize (streamReader)
		
		local releaseCount = streamReader:UInt32 ()
		for i = 1, releaseCount do
			local versionTimestamp = streamReader:UInt64 ()
			local release = package:AddRelease (versionTimestamp)
			release:Deserialize (streamReader)
		end
	end
end
