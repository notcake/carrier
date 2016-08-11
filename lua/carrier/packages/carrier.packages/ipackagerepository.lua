local self = {}
Packages.IPackageRepository = Class (self)

function self:ctor ()
end

function self:GetUrl         () Error ("IPackageRepository:GetUrl : Not implemented."        ) end
function self:GetDirectory   () Error ("IPackageRepository:GetDirectory : Not implemented."  ) end

function self:GetName        () Error ("IPackageRepository:GetDisplayName : Not implemented.") end
function self:GetDescription () Error ("IPackageRepository:GetDescription : Not implemented.") end
function self:GetReleasesUrl () Error ("IPackageRepository:GetReleasesUrl : Not implemented.") end

function self:GetPackage (name)
	Error ("IPackageRepository:GetPackage : Not implemented.")
end

function self:GetPackageCount ()
	Error ("IPackageRepository:GetPackageCount : Not implemented.")
end

function self:GetPackageEnumerator ()
	Error ("IPackageRepository:GetPackageEnumerator : Not implemented.")
end
