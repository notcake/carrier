local self = {}
Packages.PackageManager = Class (self, Util.ISavable)

function self:ctor ()
	self.RepositoryCount         = 0
	self.RepositoriesByUrl       = {} -- lowercase
	self.RepositoriesByDirectory = {} -- lowercase
	
	self.RepositoryListSerializer = Packages.PackageManager.RepositoryListSerializer ()
	
	self.Autosaver = Util.Autosaver (self)
	self.Autosaver:Load ()
end

function self:dtor ()
	self.Autosaver:dtor ()
	
	for packageRepository in self:GetRepositoryEnumerator () do
		packageRepository:dtor ()
	end
end

-- ISavable
function self:Save ()
	file.CreateDir (self:GetDirectory ())
	
	local streamWriter = IO.FileOutputStream.FromPath (self:GetRepositoryListPath (), "DATA")
	self.RepositoryListSerializer:Serialize (streamWriter, self)
	streamWriter:Close ()
end

function self:Load ()
	local streamReader = IO.FileInputStream.FromPath (self:GetRepositoryListPath (), "DATA")
	if not streamReader then return end
	
	self.RepositoryListSerializer:Deserialize (streamReader, self)
	streamReader:Close ()
end

-- PackageManager
-- Saving
function self:GetDirectory ()
	return "cakestrap"
end

function self:GetRepositoryListPath ()
	return self:GetDirectory () .. "/repositories.dat"
end

-- Repositories
function self:AddRepositoryFromUrl (url)
	local packageRepository = self:GetRepositoryByUrl (url)
	if packageRepository then return packageRepository end
	
	local repositoryInformation = Packages.PackageRepositoryInformation ()
	repositoryInformation:SetUrl (url)
	repositoryInformation:SetDirectory (self:GenerateDirectoryName (url))
	
	return self:AddRepositoryFromInformation (repositoryInformation)
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

function self:RemoveRepository (packageRepository)
	if self:GetRepositoryByUrl (packageRepository:GetUrl ()) ~= packageRepository then return end
	
	self.RepositoryCount = self.RepositoryCount - 1
	self.RepositoriesByUrl [string.lower (packageRepository:GetUrl ())] = nil
	self.RepositoriesByDirectory [string.lower (packageRepository:GetDirectory ())] = nil
	
	packageRepository:Remove ()
	self.Autosaver:UnregisterChild (packageRepository)
	self.Autosaver:Invalidate ()
end

-- Internal
function self:AddRepository (packageRepository)
	if self:GetRepositoryByUrl (packageRepository:GetUrl ()) then
		Error ("PackageManager:AddRepository : Repository " .. packageRepository:GetUrl () .. " already exists!")
		return
	end
	if self:GetRepositoryByDirectory (packageRepository:GetDirectory ()) then
		Error ("PackageManager:AddRepository : Repository directory " .. packageRepository:GetDirectory () .. " already exists!")
		return
	end
	
	self.RepositoryCount = self.RepositoryCount + 1
	self.RepositoriesByUrl [string.lower (packageRepository:GetUrl ())] = packageRepository
	self.RepositoriesByDirectory [string.lower (packageRepository:GetDirectory ())] = packageRepository
	
	self.Autosaver:RegisterChild (packageRepository)
	self.Autosaver:Invalidate ()
	
	packageRepository:Load ()
	
	return packageRepository
end

function self:AddRepositoryFromInformation (repositoryInformation)
	local packageRepository = Packages.PackageRepository (self)
	packageRepository:Copy (repositoryInformation)
	
	return self:AddRepository (packageRepository)
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
