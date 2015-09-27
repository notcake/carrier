local self = {}
CakeStrap.PackageManager = CakeStrap.Class (self)

function self:ctor ()
	self.PackageRepositories = {}
end

function self:AddPackageRepository (packageRepository)
	if self.PackageRepositories [packageRepository:GetUrl ()] then
		CakeStrap.Error ("PackageManager:AddPackageRepository : Repository " .. packageRepository:GetUrl () .. " already exists!")
	end
	
	self.PackageRepositories [packageRepository:GetUrl ()] = packageRepository
	
	return packageRepository
end

function self:AddPackageRepositoryFromInformation (packageRepositoryInformation)
	local packageRepository = CakeStrap.PackageRepository ()
	packageRepository:Copy (packageRepositoryInformation)
	
	return self:AddPackageRepository (packageRepository)
end

function self:AddPackageRepositoryFromUrl (url)
	local packageRepository = CakeStrap.PackageRepository ()
	packageRepository:SetUrl (url)
	
	return self:AddPackageRepository (packageRepository)
end
