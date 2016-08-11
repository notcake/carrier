local self = {}
Packages.IPackageRelease = Class (self)

function self:ctor ()
end

function self:GetVersionTimestamp () Error ("IPackageRepository:GetVersionTimestamp : Not implemented.") end
function self:GetVersionName      () Error ("IPackageRepository:GetVersionName : Not implemented.")      end

function self:GetSize             () Error ("IPackageRepository:GetSize : Not implemented.")             end
