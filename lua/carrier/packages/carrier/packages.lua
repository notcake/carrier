local self = {}
Carrier.Packages = Class (self)

function self:ctor ()
	self.Packages     = {}
	self.PackageCount = 0
	
	self.ManifestTimestamp = 0
	
	self.CacheDirectory = "garrysmod.io/carrier/cache"
	file.CreateDir (self.CacheDirectory)
end

function self:Update ()
	return Task.Run (
		function ()
			local response
			for i = 1, 5 do
				response = HTTP.Get ("https://garrysmod.io/api/packages/v1/latest"):await ()
				if response:IsSuccess () then break end
				
				Async.Sleep (1):await ()
			end
			
			if not response:IsSuccess () then return false end
			
			local response = util.JSONToTable (response:GetContent ())
			
			-- Check if already up to date
			if response.timestamp == self.ManifestTimestamp then return true end
			
			self.ManifestTimestamp = response.timestamp
			
			for packageName, packageInfo in pairs (response.packages) do
				local package = self:GetPackage (packageName) or Carrier.Package (packageName)
				package = package:FromJson (packageInfo)
				self:AddPackage (package)
				
				for packageReleaseVersion, packageReleaseInfo in pairs (packageInfo.releases) do
					local packageRelease = package:GetRelease (packageReleaseVersion) or Carrier.PackageRelease (packageName, packageReleaseVersion)
					packageRelease = packageRelease:FromJson (packageReleaseInfo)
					package:AddRelease (packageRelease)
				end
			end
			
			return true
		end
	)
end

-- Internal
function self:AddPackage (package)
	if self.Packages [package:GetName ()] then return end
	
	self.Packages [package:GetName ()] = package
	self.PackageCount = self.PackageCount + 1
end

function self:GetPackage (name)
	return self.Packages [name]
end

function self:GetPackageCount ()
	return self.PackageCount
end

function self:GetPackageEnumerator ()
	return ValueEnumerator (self.Packages)
end

function self:GetPackageRelease (name, version)
	local package = self.Packages [name]
	if not package then return end
	
	return package:GetRelease (version)
end
