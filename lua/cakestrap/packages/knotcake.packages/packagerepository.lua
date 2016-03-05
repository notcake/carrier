local self = {}
Packages.PackageRepository = Class (self, Packages.PackageRepositoryInformation)

function self:ctor ()
end

function self:Update ()
	local response = HTTP.Get (self:GetUrl ())
	
	return response
end
