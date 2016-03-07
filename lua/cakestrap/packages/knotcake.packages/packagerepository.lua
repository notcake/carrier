local self = {}
Packages.PackageRepository = Class (self, Packages.PackageRepositoryInformation, Util.ISavable)

function self:ctor (packageManager)
	self.PackageManager = packageManager
	
	self.ManifestSerializer = Packages.PackageRepository.ManifestSerializer ()
	
	self.Autosaver = Util.Autosaver (self)
	self.Autosaver:Load ()
end

function self:dtor ()
	self.Autosaver:dtor ()
end

-- ISavable
function self:Save ()
	file.CreateDir ("cakestrap")
	
	local streamWriter = IO.FileOutStream.FromPath ("cakestrap/" .. self:GetDirectory () .. ".dat", "DATA")
	self.ManifestSerializer:Serialize (streamWriter, self)
	streamWriter:Close ()
end

function self:Load ()
end

-- PackageRepository
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

function self:Update (print)
	print = print or function () end
	
	local httpResponse = HTTP.Get (self:GetUrl ())
	if httpResponse:GetContent () then
		print (self:GetDirectory () .. ": " .. httpResponse:GetUrl () .. " " .. httpResponse:GetCode () .. " " .. string.upper (httpResponse:GetMessage ()) .. " [" .. Util.FileSize.Format (#httpResponse:GetContent ()) .. "]")
	else
		print (self:GetDirectory () .. ": " .. httpResponse:GetUrl () .. " " .. httpResponse:GetCode () .. " " .. string.upper (httpResponse:GetMessage ()))
	end
	
	if not httpResponse:IsSuccess () then return httpResponse end
	
	local repositoryInformation = util.JSONToTable (httpResponse:GetContent ())
	if not repositoryInformation then
		print (self:GetDirectory () .. ": Invalid JSON!")
		return httpResponse
	end
	
	self:SetName        (tostring (repositoryInformation.name        or ""))
	self:SetDescription (tostring (repositoryInformation.description or ""))
	self:SetReleasesUrl (tostring (repositoryInformation.releases    or ""))
	
	httpResponse = HTTP.Get (self:GetAbsoluteReleasesUrl ())
	if httpResponse:GetContent () then
		print (self:GetDirectory () .. ": " .. httpResponse:GetUrl () .. " " .. httpResponse:GetCode () .. " " .. string.upper (httpResponse:GetMessage ()) .. " [" .. Util.FileSize.Format (#httpResponse:GetContent ()) .. "]")
	else
		print (self:GetDirectory () .. ": " .. httpResponse:GetUrl () .. " " .. httpResponse:GetCode () .. " " .. string.upper (httpResponse:GetMessage ()))
	end
	
	return httpResponse
end
