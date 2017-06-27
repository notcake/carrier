local self = {}
Packages.IPackage = Interface (self)

function self:ctor ()
end

function self:GetName        () Error ("IPackage:GetName : Not implemented.")        end
function self:GetDisplayName () Error ("IPackage:GetDisplayName : Not implemented.") end

function self:GetDescription () Error ("IPackage:GetDescription : Not implemented.") end

function self:GetRelease (versionTimestamp)
	Error ("IPackage:GetRelease : Not implemented.")
end

function self:GetReleaseCount ()
	Error ("IPackage:GetReleaseCount : Not implemented.")
end

function self:GetReleaseEnumerator ()
	Error ("IPackage:GetReleaseEnumerator : Not implemented.")
end
