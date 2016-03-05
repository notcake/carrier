local self = {}
Packages.PackageManager = Class (self)

function self:ctor ()
	self.RepositoryCount         = 0
	self.RepositoriesByUrl       = {} -- lowercase
	self.RepositoriesByDirectory = {} -- lowercase
	
	self.RepositoryListSerializer = Packages.PackageManager.RepositoryListSerializer ()
	self.SaveNeeded = false
end

function self:AddRepositoryFromUrl (url)
	local repository = self:GetRepositoryByUrl (url)
	if repository then return repository end
	
	repository = Packages.PackageRepository ()
	repository:SetUrl (url)
	repository:SetDirectory (self:GenerateDirectoryName (url))
	
	return self:AddRepository (repository)
end

function self:GetRepositoryByUrl (url)
	url = string.lower (url)
	return self.RepositoriesByUrl [url]
end

function self:GetRepositoryByDirectory (directory)
	directory = string.lower (directory)
	return self.RepositoriesByDirectory [directory]
end

function self:GetRepositoryCount ()
	return self.RepositoryCount
end

function self:GetRepositoryEnumerator ()
	return ValueEnumerator (self.RepositoriesByUrl)
end

-- Internal
function self:AddRepository (repository)
	if self:GetRepositoryByUrl (repository:GetUrl ()) then
		Error ("PackageManager:AddRepository : Repository " .. repository:GetUrl () .. " already exists!")
		return
	end
	if self:GetRepositoryByDirectory (repository:GetDirectory ()) then
		Error ("PackageManager:AddRepository : Repository directory " .. repository:GetDirectory () .. " already exists!")
		return
	end
	
	self.RepositoryCount = self.RepositoryCount + 1
	self.RepositoriesByUrl [string.lower (repository:GetUrl ())] = repository
	self.RepositoriesByDirectory [string.lower (repository:GetDirectory ())] = repository
	
	return repository
end

function self:AddRepositoryFromInformation (repositoryInformation)
	local repository = Packages.PackageRepository ()
	repository:Copy (repositoryInformation)
	
	return self:AddRepository (repository)
end

function self:GenerateDirectoryName (url)
	local fileName = url
	fileName = string.gsub (fileName, "^.-://", "")
	fileName = string.gsub (fileName, "[:/].*$", "")
	fileName = string.gsub (fileName, "[^a-zA-Z0-9%.]+", "_")
	fileName = string.lower (fileName)
	
	if not self.RepositoriesByDirectory [fileName] then return fileName end
	
	local i = 2
	fileName = fileName .. "_"
	while self.RepositoriesByDirectory [fileName .. i] do
		i = i + 1
	end
	
	return fileName .. i
end

function self:Save ()
	file.CreateDir ("cakestrap")
	
	local streamWriter = IO.FileOutStream.FromPath ("cakestrap/repositories.bin", "DATA")
	self.RepositoryListSerializer:Serialize (steamWriter, self)
	streamWriter:Close ()
end

function self:Load ()
	local streamReader = IO.FileInStream.FromPath ("cakestrap/repositories.bin", "DATA")
	if not streamReader then return end
	
	self.RepositoryListSerializer:Deserialize (steamReader, self)
	streamReader:Close ()
	
	self.SaveNeeded = false
end
