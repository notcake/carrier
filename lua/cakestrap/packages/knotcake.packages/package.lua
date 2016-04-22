local self = {}
Packages.Package = Class (self, Packages.PackageInformation)

function self:ctor (packageRepository, autosaver)
	self.PackageRepository   = packageRepository
	self.Autosaver           = autosaver
	
	self.ReleaseCount        = 0
	self.ReleasesByTimestamp = {}
end

-- PackageInformation
function self:ToPackageReference (repositoryUrl)
	repositoryUrl = repositoryUrl or self:GetPackageRepository ():GetUrl ()
	return Packages.PackageReference (repositoryUrl, self.PackageName, self.VersionTimestamp)
end

-- Package
-- Parent
function self:GetPackageRepository ()
	return self.PackageRepository
end

function self:Update (packageTable)
	self:FromTable (packageTable)
	
	for _, releaseTable in ipairs (packageTable.releases) do
		PrintTable (releaseTable)
	end
end

-- Releases
function self:GetReleaseByTimestamp (versionTimestamp)
	return self.ReleasesByTimestamp [versionTimestamp]
end

function self:GetReleaseCount ()
	return self.ReleaseCount
end

function self:GetReleaseEnumerator ()
	return ValueEnumerator (self.ReleasesByTimestamp)
end

-- Internal
function self:AddRelease (versionTimestamp)
	local packageRelease = self:GetReleaseByTimestamp (versionTimestamp)
	if packageRelease then return packageRelease end
	
	packageRelease = Packages.PackageRelease ()
	packageRelease:SetVersionTimestamp (versionTimestamp)
	
	self.ReleaseCount = self.ReleaseCount + 1
	self.ReleasesByTimestamp [packageRelease:GetVersionTimestamp ()] = packageRelease
	
	self.Autosaver:RegisterChild (packageRelease)
	self.Autosaver:Invalidate ()
	
	return packageRelease
end

function self:RemoveRelease (packageRelease)
	if self:GetReleaseByTimestamp (packageRelease:GetVersionTimestamp ()) ~= packageRelease then return end
	
	self.ReleaseCount = self.ReleaseCount - 1
	self.ReleasesByTimestamp [packageRelease:GetName ()] = nil
	
	self.Autosaver:UnregisterChild (packageRelease)
	self.Autosaver:Invalidate ()
end
