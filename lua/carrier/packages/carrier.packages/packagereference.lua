local self = {}
Packages.PackageReference = Class (self, ICloneable, ISerializable)

function Packages.PackageReference.FromString (url, packageReference)
	return Packages.PackageReference.FromUrl (url, packageReference)
end

function Packages.PackageReference.FromUrl (url, packageReference)
	local repositoryUrl, packageName, packageVersionTimestamp = string.match (url, "^(.*);(.*);(.*)$")
	if not repositoryUrl then return nil end
	
	packageReference = packageReference or Packages.PackageReference ()
	
	if repositoryUrl           == "" then repositoryUrl           = nil end
	if packageVersionTimestamp == "" then packageVersionTimestamp = nil end
	packageVersionTimestamp = tonumber (packageVersionTimestamp)
	
	packageReference:SetRepositoryUrl (repositoryUrl)
	packageReference:SetPackageName (packageName)
	packageReference:SetPackageVersionTimestamp (packageVersionTimestamp)
	
	return packageReference
end

self.RepositoryUrl           = Property (nil, "StringN16?")
self.PackageName             = Property (nil, "StringN16")
self.PackageVersionTimestamp = Property (nil, "UInt64?")

function self:ctor (repositoryUrl, packageName, packageVersionTimestamp)
	self.RepositoryUrl           = repositoryUrl
	self.PackageName             = packageName
	self.PackageVersionTimestamp = packageVersionTimestamp
end

function self:ToUrl ()
	local repositoryUrl           = self:GetRepositoryUrl () or ""
	local packageName             = self:GetPackageName ()
	local packageVersionTimestamp = self:GetPackageVersionTimestamp () or ""
	packageVersionTimestamp = tostring (packageVersionTimestamp)
	
	return repositoryUrl .. ";" .. packageName .. ";" .. packageVersionTimestamp
end

function self:ToString ()
	return self:ToUrl ()
end
