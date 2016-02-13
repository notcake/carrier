local self = {}
CakeStrap.PackageReference = CakeStrap.Class (self, CakeStrap.ICloneable, CakeStrap.ISerializable)

function CakeStrap.PackageReference.FromString (url, packageReference)
	return CakeStrap.PackageReference.FromUrl (url, packageReference)
end

function CakeStrap.PackageReference.FromUrl (url, packageReference)
	local repositoryUrl, packageName, packageVersionTimestamp = string.match (url, "^(.*);(.*);(.*)$")
	if not repositoryUrl then return nil end
	
	packageReference = packageReference or CakeStrap.PackageReference ()
	
	if repositoryUrl           == "" then repositoryUrl           = nil end
	if packageVersionTimestamp == "" then packageVersionTimestamp = nil end
	packageVersionTimestamp = tonumber (packageVersionTimestamp)
	
	packageReference:SetRepositoryUrl (repositoryUrl)
	packageReference:SetPackageName (packageName)
	packageReference:SetPackageVersionTimestamp (packageVersionTimestamp)
	
	return packageReference
end

self.RepositoryUrl           = CakeStrap.Property (nil, "StringN16"):SetNullable (true)
self.PackageName             = CakeStrap.Property (nil, "StringN16")
self.PackageVersionTimestamp = CakeStrap.Property (nil, "UInt64"):SetNullable (true)

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
