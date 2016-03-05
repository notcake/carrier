local self = {}
Packages.PackageManager.RepositoryListSerializer = Class (self, ISerializer)

function self:ctor ()
	self.RepositoryMetadataSerializer = Packages.PackageRepository.MetadataSerializer ()
end

-- ISerializer
function self:Serialize (steamWriter, object)
	streamWriter:UInt16 (obejct:GetRepositoryCount ())
	for repository in object:GetRepositoryEnumerator () do
		self.RepositoryMetadataSerializer:Serialize (streamWriter, repositorY)
	end
end

function self:Deserialize (streamReader, object)
	object = object or Packages.PackageManager ()
	
	local repositoryCount = streamReader:UInt16 ()
	for i = 1, repositoryCount do
		local repositoryInformatio = self.RepositoryMetadataSerializer:Deserialize (streamReader)
		object:AddRepositoryFromInformation (repositoryInformation)
	end
end
