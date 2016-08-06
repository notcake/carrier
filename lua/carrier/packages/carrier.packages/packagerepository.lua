local self = {}
Packages.PackageRepository = Class (self, Packages.PackageRepositoryInformation, Util.ISavable)

function self:ctor (packageManager)
	self.PackageManager = packageManager
	
	self.PackageCount   = 0
	self.PackagesByName = {}
	
	self.ManifestSerializer = Packages.PackageRepository.ManifestSerializer ()
	
	self.Autosaver = Util.Autosaver (self)
end

function self:dtor ()
	self.Autosaver:dtor ()
end

-- ISavable
function self:Save ()
	file.CreateDir ("carrier")
	
	local streamWriter = IO.FileOutputStream.FromPath (self:GetManifestPath (), "DATA")
	self.ManifestSerializer:Serialize (streamWriter, self)
	streamWriter:Close ()
end

function self:Load ()
	local streamReader = IO.FileInputStream.FromPath (self:GetManifestPath (), "DATA")
	if not streamReader then return end
	
	self.ManifestSerializer:Deserialize (streamReader, self)
	streamReader:Close ()
end

-- PackageRepository
-- Parent
function self:GetPackageManager ()
	return self.PackageManager
end

function self:Remove ()
	if not self.PackageManager then return end
	
	self.Autosaver:SetEnabled (false)
	local packageManager = self.PackageManager
	self.PackageManager = nil
	packageManager:RemoveRepository (self)
end

-- Saving
function self:GetManifestPath ()
	return self:GetPackageManager ():GetDirectory () .. "/" .. self:GetDirectory () .. ".dat"
end

function self:GetAbsoluteReleasesUrl ()
	local releasesUrl = self:GetReleasesUrl ()
	if string.sub (releasesUrl, 1, 1) == "/" then
		local prefix = string.match (self:GetUrl (), "^[^:]+://[^/]+")
		prefix = prefix or string.match (self:GetUrl (), "^[^/]+")
		return prefix .. releasesUrl
	else
		return releasesUrl
	end
end

function self:Update (textSink)
	textSink = textSink or Text.NullTextSink
	
	local totalDownloaded = 0
	
	-- Fetch repository metadata
	local httpResponse = HTTP.Get (self:GetUrl ())
	totalDownloaded = totalDownloaded + httpResponse:GetContentLength ()
	textSink:WriteLine (self:GetDirectory () .. ": " .. self:FormatHttpResponse (httpResponse))
	
	if not httpResponse:IsSuccess () then return totalDownloaded end
	
	-- Process metadata
	local repositoryInformation = util.JSONToTable (httpResponse:GetContent ())
	if not repositoryInformation then
		textSink:WriteLine (self:GetDirectory () .. ": Invalid JSON!")
		return totalDownloaded
	end
	
	self:SetName        (tostring (repositoryInformation.name        or ""))
	self:SetDescription (tostring (repositoryInformation.description or ""))
	self:SetReleasesUrl (tostring (repositoryInformation.releases    or ""))
	
	-- Fetch releases
	httpResponse = HTTP.Get (self:GetAbsoluteReleasesUrl ())
	totalDownloaded = totalDownloaded + httpResponse:GetContentLength ()
	textSink:WriteLine (self:GetDirectory () .. ": " .. self:FormatHttpResponse (httpResponse))
	
	if not httpResponse:IsSuccess () then return totalDownloaded end

	-- Process releases
	local releases = util.JSONToTable (httpResponse:GetContent ())
	if not releases then
		textSink:WriteLine (self:GetDirectory () .. ": Invalid JSON!")
		return totalDownloaded
	end
	
	for _, packageTable in ipairs (releases) do
		local package = self:AddPackage (packageTable.name)
		package:Update (packageTable)
	end
	
	return totalDownloaded
end

-- Packages
function self:GetPackageByName (name)
	return self.PackagesByName [name]
end

function self:GetPackageCount ()
	return self.PackageCount
end

function self:GetPackageEnumerator ()
	return ValueEnumerator (self.PackagesByName)
end

-- Internal
function self:AddPackage (name)
	local package = self:GetPackageByName (name)
	if package then return package end
	
	package = Packages.Package (self, self.Autosaver)
	package:SetName (name)
	
	self.PackageCount = self.PackageCount + 1
	self.PackagesByName [package:GetName ()] = package
	
	self.Autosaver:RegisterChild (package)
	self.Autosaver:Invalidate ()
	
	return package
end

function self:RemovePackage (package)
	if self:GetPackageByName (package:GetName ()) ~= package then return end
	
	self.PackageCount = self.PackageCount - 1
	self.PackagesByName [package:GetName ()] = nil
	
	self.Autosaver:UnregisterChild (package)
	self.Autosaver:Invalidate ()
end

function self:FormatHttpResponse (httpResponse)
	if httpResponse:GetContent () then
		return httpResponse:GetUrl () .. " " .. httpResponse:GetCode () .. " " .. string.upper (httpResponse:GetMessage ()) .. " [" .. Util.FileSize.Format (#httpResponse:GetContent ()) .. "]"
	else
		return httpResponse:GetUrl () .. " " .. httpResponse:GetCode () .. " " .. string.upper (httpResponse:GetMessage ())
	end
end
