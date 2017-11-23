local self = {}
Carrier.IPackageRelease = Interface (self)

function self:ctor ()
end

function self:GetName ()
	Error ("IPackageRelease:GetName : Not implemented.")
end

function self:GetVersion ()
	Error ("IPackageRelease:GetVersion : Not implemented.")
end

function self:GetTimestamp ()
	Error ("IPackageRelease:GetTimestamp : Not implemented.")
end

function self:IsDeprecated ()
	Error ("IPackageRelease:IsDeprecated : Not implemented.")
end

function self:IsDeveloper ()
	Error ("IPackageRelease:IsDeveloper : Not implemented.")
end

-- Dependencies
function self:GetDependencyCount ()
	Error ("IPackageRelease:GetDependencyCount : Not implemented.")
end

function self:GetDependencyEnumerator ()
	Error ("IPackageRelease:GetDependencyEnumerator : Not implemented.")
end

-- Dependents
function self:GetDependentCount ()
	Error ("IPackageRelease:GetDependentCount : Not implemented.")
end

function self:GetDependentEnumerator ()
	Error ("IPackageRelease:GetDependentEnumerator : Not implemented.")
end
