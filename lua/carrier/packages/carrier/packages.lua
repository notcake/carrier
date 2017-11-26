local self = {}
Carrier.Packages = Class (self, ISerializable)
self.Signature     = "\xffPKG\r\n\x1a\n"
self.FormatVersion = 1

local sv_allowcslua = GetConVar ("sv_allowcslua")
local carrier_developer_sv = CreateConVar ("carrier_developer_sv", "0", FCVAR_ARCHIVE + FCVAR_REPLICATED)
local carrier_developer_cl = CLIENT and CreateClientConVar ("carrier_developer_cl", "0", true, false) or nil
local carrier_developer    = CLIENT and carrier_developer_cl or carrier_developer_sv

function self:ctor ()
	self.Packages     = {}
	self.PackageCount = 0
	
	self.ManifestLoaded = false
	self.ManifestTimestamp = 0
	self.Path           = "garrysmod.io/carrier/packages.dat"
	self.CacheDirectory = "garrysmod.io/carrier/cache"
	file.CreateDir (self.CacheDirectory)
	
	self.ServerLoadRoots = {}
	self.ClientLoadRoots = {}
	self.LocalLoadRoots  = nil
	self.LoadedPackages  = {}
	
	self:UpdateLocalDeveloperPackages ()
end

-- ISerializable
function self:Serialize (streamWriter)
	streamWriter:Bytes  (self.Signature)
	streamWriter:UInt32 (self.FormatVersion)
	streamWriter:UInt32 (0)
	streamWriter:UInt64 (self.ManifestTimestamp)
	
	streamWriter:UInt32 (self.PackageCount)
	for package in self:GetPackageEnumerator () do
		streamWriter:StringN8 (package:GetName ())
		package:Serialize (streamWriter)
	end
	
	streamWriter:SeekAbsolute (#self.Signature + 4)
	streamWriter:UInt32 (streamWriter:GetSize ())
	
	return true
end

function self:Deserialize (streamReader)
	local signature = streamReader:Bytes (#self.Signature)
	if signature ~= self.Signature then return false end
	
	local formatVersion = streamReader:UInt32 ()
	if formatVersion ~= self.FormatVersion then return false end
	
	local length = streamReader:UInt32 ()
	if length ~= streamReader:GetSize () then return false end
	
	self.ManifestTimestamp = streamReader:UInt64 ()
	local packageCount = streamReader:UInt32 ()
	for i = 1, packageCount do
		local packageName = streamReader:StringN8 ()
		local package = self:GetPackage (packageName) or Carrier.Package (packageName)
		self:AddPackage (package)
		
		package:Deserialize (streamReader)
	end
	
	return true
end

-- Developer
function self:IsLocalDeveloperEnabled ()
	return carrier_developer:GetBool () and (SERVER or sv_allowcslua:GetBool ())
end

function self:IsServerDeveloperEnabled ()
	return carrier_developer_sv:GetBool () and util.NetworkStringToID ("Carrier.RequestDeveloperPackageList") ~= 0
end

-- Packages
function self:Initialize ()
	local t0 = SysTime ()
	if not self:IsMetadataLoaded () then
		self:LoadMetadata ()
	end
	
	self.ServerLoadRoots = self:GetLoadRoots ("carrier/autoload/server/", self.ServerLoadRoots)
	self.ClientLoadRoots = self:GetLoadRoots ("carrier/autoload/client/", self.ClientLoadRoots)
	
	local sharedLoadRoots = self:GetLoadRoots ("carrier/autoload/")
	for packageName, _ in pairs (sharedLoadRoots) do
		self.ServerLoadRoots [packageName] = true
		self.ClientLoadRoots [packageName] = true
	end
	
	self.LocalLoadRoots = CLIENT and self.ClientLoadRoots or self.ServerLoadRoots
	
	if self:IsLocalDeveloperEnabled () then
		for packageName, _ in pairs (self.LocalLoadRoots) do
			self:Load (packageName)
		end
	end
	
	Task.Run (
		function ()
			self:Update ():Await ()
			
			local downloadSet = {}
			downloadSet = self:ComputePackageDependencySet ("Carrier", downloadSet)
			for packageName, _ in pairs (self.LocalLoadRoots) do
				downloadSet = self:ComputePackageDependencySet (packageName, downloadSet)
			end
			if SERVER then
				for packageName, _ in pairs (self.ClientLoadRoots) do
					downloadSet = self:ComputePackageDependencySet (packageName, downloadSet)
				end
			end
			
			local success = true
			for packageName, packageReleaseVersion in pairs (downloadSet) do
				success = success and self:Download (packageName, packageReleaseVersion):Await ()
			end
			
			for packageName, _ in pairs (self.LocalLoadRoots) do
				self:Load (packageName)
			end
		end
	)
	
	local dt = SysTime () - t0
	Carrier.Log (string.format ("Initialize took %.2f ms", dt * 1000))
end

function self:Uninitialize ()
	for packageName, _ in pairs (self.LoadedPackages) do
		self:Unload (packageName)
	end
end

-- Saving
function self:SaveMetadata ()
	local outputStream = IO.FileOutputStream.FromPath (self.Path, "DATA")
	if not outputStream then
		Carrier.Warning ("Could not open " .. self.Path .. " for saving!")
		return
	end
	self:Serialize (outputStream)
	outputStream:Close ()
	
	Carrier.Log ("Saved to " .. self.Path)
end

function self:LoadMetadata ()
	local inputStream = IO.FileInputStream.FromPath (self.Path, "DATA")
	if not inputStream then return end
	local success = self:Deserialize (inputStream)
	inputStream:Close ()
	
	if success then
		self.ManifestLoaded = true
		Carrier.Log ("Loaded from " .. self.Path)
	else
		Carrier.Log ("Load from " .. self.Path .. " failed!")
	end
end

function self:IsMetadataLoaded ()
	return self.ManifestLoaded
end

-- Packages
function self:GetPackage (packageName)
	return self.Packages [packageName]
end

function self:GetPackageCount ()
	return self.PackageCount
end

function self:GetPackageEnumerator ()
	return ValueEnumerator (self.Packages)
end

function self:GetLocalDeveloperRelease (packageName)
	local package = self.Packages [packageName]
	
	return package and package:GetLocalDeveloperRelease ()
end

function self:GetLatestRelease (packageName)
	local package = self.Packages [packageName]
	
	return package and package:GetLatestRelease ()
end

function self:GetPackageRelease (packageName, packageReleaseVersion)
	local package = self.Packages [packageName]
	
	return package and package:GetRelease (packageReleaseVersion)
end

function self:IsPackageReleaseAvailable (packageName, packageReleaseVersion)
	local packageRelease = packageReleaseVersion and self:GetPackageRelease (packageName, packageReleaseVersion) or self:GetLatestRelease (packageName)
	return packageRelease and packageRelease:IsAvailable () or false
end

function self:IsPackageReleaseAvailableRecursive (packageName, packageReleaseVersion)
	local packageRelease = packageReleaseVersion and self:GetPackageRelease (packageName, packageReleaseVersion) or self:GetLatestRelease (packageName)
	if not packageRelease then return false end
	
	local dependencySet = self:ComputePackageReleaseDependencySet (packageRelease)
	for packageName, packageReleaseVersion in pairs (dependencySet) do
		if not self:IsPackageReleaseAvailable (packageName, packageReleaseVersion) then
			return false
		end
	end
	
	return true
end

-- Dependencies
function self:ComputePackageDependencySet (packageName, dependencySet)
	local package = self:GetPackage (packageName)
	local packageRelease = package and package:GetLatestRelease ()
	return self:ComputePackageReleaseDependencySet (packageRelease, dependencySet)
end

function self:ComputePackageReleaseDependencySet (packageRelease, dependencySet)
	local dependencySet = dependencySet or {}
	if not packageRelease then return dependencySet end
	
	dependencySet [packageRelease:GetName ()] = packageRelease:GetVersion ()
	
	for dependencyName, dependencyVersion in packageRelease:GetDependencyEnumerator () do
		if not dependencySet [dependencyName] then
			dependencySet = self:ComputePackageReleaseDependencySet (self:GetPackageRelease (dependencyName,dependencyVersion), dependencySet)
		end
	end
	
	return dependencySet
end

-- Loading
function self:Assimilate (package, packageRelease, environment, exports, destructor)
	package:Assimilate (packageRelease, environment, exports, destructor)
	self.LoadedPackages [package:GetName ()] = package
end

function self:Load (packageName, packageReleaseVersion)
	local package = self:GetPackage (packageName)
	if not package then
		Carrier.Warning ("Load: Package " .. packageName .. " not found!")
		return
	end
	
	if not packageReleaseVersion then
		local packageRelease = nil
		
		-- Prioritize developer packages if developer mode is on
		if self:IsLocalDeveloperEnabled () then
			packageRelease = packageRelease or package:GetLocalDeveloperRelease ()
		end
		
		-- Pick the latest release
		packageRelease = packageRelease or package:GetLatestRelease ()
		
		-- Fallback onto a developer package
		if SERVER or sv_allowcslua:GetBool () then
			if not packageRelease or not packageRelease:IsAvailable () then
				packageRelease = package:GetLocalDeveloperRelease () or packageRelease
			end
		end
		
		packageReleaseVersion = packageRelease and packageRelease:GetVersion ()
	end
	if not packageReleaseVersion then
		Carrier.Warning ("Load: No releases found for " .. packageName .. "!")
		return
	end
	
	self.LoadedPackages [packageName] = package
	return package:Load (packageReleaseVersion)
end

function self:LoadProvider (packageName)
	return self:Load (packageName .. ".GarrysMod")
end

function self:Unload (packageName)
	local package = self.LoadedPackages [packageName]
	if not package then return end
	
	if package == true then
		Carrier.Warning ("Dependency cycle involving package " .. packageName .. "!")
		return
	end
	
	self.LoadedPackages [packageName] = true
	if package:GetLoadedRelease () then
		for dependentName, dependentVersion in package:GetLoadedRelease ():GetDependentEnumerator () do
			self:Unload (dependentName)
		end
	else
		Carrier.Warning ("Loaded release missing for " .. packageName .. ", dependencies cannot be unloaded in the right order!")
	end
	
	package:Unload ()
	self.LoadedPackages [packageName] = nil
end

-- Manifest
function self:Download (packageName, packageReleaseVersion)
	return Task.Run (
		function ()
			local packageRelease = self:GetPackageRelease (packageName, packageReleaseVersion)
			if not packageRelease then return false end
			
			if file.Exists (self.CacheDirectory .. "/" .. packageRelease:GetFileName (), "DATA") then return true end
			
			local response
			local url = "https://garrysmod.io/api/packages/v1/download?name=" .. HTTP.EncodeUriComponent (packageName) .. "&version=" .. HTTP.EncodeUriComponent (packageReleaseVersion)
			for i = 1, 5 do
				response = HTTP.Get (url):await ()
				if response:IsSuccess () then break end
				
				if i ~= 5 then
					local delay = 1 * math.pow (2, i - 1)
					Carrier.Warning ("Failed to fetch from " .. url .. ", retrying in " .. delay .. " second(s)...")
					Async.Sleep (delay):await ()
				end
			end
			
			if not response:IsSuccess () then
				Carrier.Log ("Failed to download " .. packageName .. " " .. packageReleaseVersion)
				return false
			end
			
			if string.sub (response:GetContent (), 1, #PackageFile.Signature) == PackageFile.Signature then
				Carrier.Log ("Downloaded " .. packageName .. " " .. packageReleaseVersion)
				file.Write (self.CacheDirectory .. "/" .. packageRelease:GetFileName (), response:GetContent ())
				return true
			else
				Carrier.Log ("Downloaded " .. packageName .. " " .. packageReleaseVersion .. ", but bad signature")
				return false
			end
		end
	)
end

function self:DownloadRecursive (packageName, packageReleaseVersion)
	return Task.Run (
		function ()
			local packageRelease = packageReleaseVersion and self:GetPackageRelease (packageName, packageReleaseVersion) or self:GetLatestRelease (packageName)
			if not packageRelease then return false end
			local downloadSet = self:ComputePackageReleaseDependencySet (packageRelease)
			
			local success = true
			for packageName, packageReleaseVersion in pairs (downloadSet) do
				success = success and self:Download (packageName, packageReleaseVersion):Await ()
			end
			
			return true
		end
	)
end

function self:Update ()
	return Task.Run (
		function ()
			local response
			for i = 1, 5 do
				response = HTTP.Get ("https://garrysmod.io/api/packages/v1/latest"):Await ()
				if response:IsSuccess () then break end
				
				if i ~= 5 then
					local delay = 1 * math.pow (2, i - 1)
					Carrier.Warning ("Failed to fetch from https://garrysmod.io/api/packages/v1/latest, retrying in " .. delay .. " second(s)...")
					Async.Sleep (delay):await ()
				end
			end
			
			if not response:IsSuccess () then
				Carrier.Warning ("Failed to download package list.")
				return false
			end
			
			local response = util.JSONToTable (response:GetContent ())
			
			-- Check if already up to date
			if response.timestamp == self.ManifestTimestamp then
				Carrier.Log ("Package manifest is up to date (" .. self.ManifestTimestamp .. ").")
				return true
			end
			
			Carrier.Log ("Updating manifest " .. self.ManifestTimestamp .. " to " .. response.timestamp .. "...")
			self.ManifestTimestamp = response.timestamp
			
			-- Check bootstrap
			local bootstrapSignature = file.Read ("garrysmod.io/carrier/bootstrap.signature.dat", "DATA")
			if Base64.Decode (response.bootstrapSignature) ~= bootstrapSignature then
				Carrier.Log ("Updating bootstrap...")
				self:UpdateBootstrap ():Await ()
			end
			
			-- Package releases
			local packageReleaseSet = {}
			for packageName, packageInfo in pairs (response.packages) do
				local package = self:GetPackage (packageName) or Carrier.Package (packageName)
				package = package:FromJson (packageInfo)
				self:AddPackage (package)
				
				for packageReleaseVersion, packageReleaseInfo in pairs (packageInfo.releases) do
					local packageRelease = package:GetRelease (packageReleaseVersion) or Carrier.PackageRelease (packageName, packageReleaseVersion)
					packageRelease:SetDeprecated (false)
					packageReleaseSet [packageRelease] = true
					packageRelease = packageRelease:FromJson (packageReleaseInfo)
					package:AddRelease (packageRelease)
				end
			end
			
			-- Populate dependents
			for packageRelease, _ in pairs (packageReleaseSet) do
				for dependencyName, dependencyVersion in packageRelease:GetDependencyEnumerator () do
					local dependency = self:GetPackageRelease (dependencyName, dependencyVersion)
					if dependency then
						dependency:AddDependent (packageRelease:GetName (), packageRelease:GetVersion ())
					end
				end
			end
			
			-- Deprecate old packages
			for package in self:GetPackageEnumerator () do
				for packageRelease in package:GetReleaseEnumerator () do
					if not packageRelease:IsDeveloper () and
					   not packageReleaseSet [packageRelease] then
						packageRelease:SetDeprecated (true)
					end
				end
			end
			
			-- Save
			self:SaveMetadata ()
			
			return true
		end
	)
end

function self:UpdateBootstrap ()
	return Task.Run (
		function ()
			local response
			for i = 1, 5 do
				response = HTTP.Get ("https://garrysmod.io/api/packages/v1/bootstrap"):Await ()
				if response:IsSuccess () then break end
				
				if i ~= 5 then
					local delay = 1 * math.pow (2, i - 1)
					Carrier.Warning ("Failed to fetch from https://garrysmod.io/api/packages/v1/bootstrap, retrying in " .. delay .. " second(s)...")
					Async.Sleep (delay):await ()
				end
			end
			
			if not response:IsSuccess () then
				Carrier.Warning ("Failed to download bootstrap.")
				return false
			end
			
			local response = util.JSONToTable (response:GetContent ())
			if not response then
				Carrier.Warning ("Invalid bootstrap response.")
				return false
			end
			
			file.Write ("garrysmod.io/carrier/bootstrap.dat",           Base64.Decode (response.package))
			file.Write ("garrysmod.io/carrier/bootstrap.signature.dat", Base64.Decode (response.signature))
		end
	)
end

function self:UpdateLocalDeveloperPackages ()
	local pathId = CLIENT and "LCL" or "LSV"
	local files, folders = file.Find ("carrier/packages/*", pathId)
	
	local basePaths        = {}
	local constructorPaths = {}
	local destructorPaths  = {}
	for _, v in ipairs (files) do
		basePaths        [#basePaths + 1] = "carrier/packages/" .. v
		constructorPaths [#basePaths]     = "carrier/packages/" .. v
		destructorPaths  [#basePaths]     = nil
	end
	for _, v in ipairs (folders) do
		basePaths        [#basePaths + 1] = "carrier/packages/" .. v
		constructorPaths [#basePaths]     = "carrier/packages/" .. v .. "/_ctor.lua"
		destructorPaths  [#basePaths]     = "carrier/packages/" .. v .. "/_dtor.lua"
	end
	
	local dependencies = {}
	local replacements = {}
	for i = 1, #basePaths do
		local packageRelease, dependencySet, previousPackageRelease = self:UpdateLocalDeveloperPackage (basePaths [i], constructorPaths [i], destructorPaths [i], pathId)
		if packageRelease then
			dependencies [packageRelease] = dependencySet
			replacements [packageRelease] = previousPackageRelease
		end
	end
	
	-- Fixup dependencies
	for packageRelease, previousPackageRelease in pairs (replacements) do
		-- Replace in dependencies
		for dependentName, dependentVersion in previousPackageRelease:GetDependentEnumerator () do
			local dependent = self:GetPackageRelease (dependentName, dependentVersion)
			if dependent then
				dependent:RemoveDependency (previousPackageRelease:GetName (), previousPackageRelease:GetVersion ())
				dependent:AddDependency (packageRelease:GetName (), packageRelease:GetVersion ())
			end
		end
		
		-- Clear from dependents
		for dependencyName, dependencyVersion in previousPackageRelease:GetDependencyEnumerator () do
			local dependency = self:GetPackageRelease (dependencyName, dependencyVersion)
			if dependency then
				dependent:RemoveDependent (previousPackageRelease:GetName (), previousPackageRelease:GetVersion ())
			end
		end
	end
	
	-- Populate dependencies
	for packageRelease, dependencySet in pairs (dependencies) do
		for dependencyName, _ in pairs (dependencySet) do
			local dependencyPackage = self:GetPackage (dependencyName)
			local dependency = dependencyPackage and dependencyPackage:GetLocalDeveloperRelease ()
			if dependency then
				packageRelease:AddDependency (dependencyName, dependency:GetVersion ())
				dependency:AddDependent (packageRelease:GetName (), packageRelease:GetVersion ())
			end
		end
	end
end

-- Internal
function self:AddPackage (package)
	if self.Packages [package:GetName ()] then return end
	
	self.Packages [package:GetName ()] = package
	self.PackageCount = self.PackageCount + 1
end

function self:GetLoadRoots (path, loadRoots)
	local loadRoots = loadRoots or {}
	
	local autoloadSet = {}
	autoloadSet = Array.ToSet (file.Find (path .. "*.lua", "LUA"), autoloadSet)
	if SERVER then
		autoloadSet = Array.ToSet (file.Find (path .. "*.lua", "LSV"), autoloadSet)
	end
	if CLIENT and sv_allowcslua:GetBool () then
		autoloadSet = Array.ToSet (file.Find (path .. "*.lua", "LCL"), autoloadSet)
	end
	
	for autoload in pairs (autoloadSet) do
		local f = CompileFile (path .. autoload)
		if f then
			setfenv (f, {})
			
			for _, packageName in ipairs ({ f () }) do
				loadRoots [packageName] = true
			end
		end
	end
	
	return loadRoots
end

function self:ParsePackageConstructor (constructorPath, pathId)
	local code = file.Read (constructorPath, pathId)
	if not code then return nil, nil end
	local packageName = string.match (code, "%-%-%s*PACKAGE%s*([^%s]+)")
	if not packageName then return nil, nil end
	
	-- Parse dependencies
	local dependencySet = {}
	for require, packageName in string.gmatch (code, "(require_?p?r?o?v?i?d?e?r?)%s*%(?[\"']([^\"]-)[\"']%)?") do
		if require == "require" then
			dependencySet [packageName] = true
		elseif require == "require_provider" then
			dependencySet [packageName .. ".GarrysMod"] = true
		end
	end
	
	return packageName, dependencySet
end

function self:UpdateLocalDeveloperPackage (basePath, constructorPath, destructorPath, pathId)
	local packageName, dependencySet = self:ParsePackageConstructor (constructorPath, pathId)
	if not packageName then return nil, nil end
	
	local package = self:GetPackage (packageName)
	if not package then
		package = Carrier.Package (packageName)
		self:AddPackage (package)
	end
	
	local destructorExists = destructorPath and file.Exists (destructorPath, pathId) or false
	local packageRelease = Carrier.LocalDeveloperPackageRelease (packageName, basePath, constructorPath, destructorExists and destructorPath or nil, pathId)
	local previousPackageRelease = package:GetLocalDeveloperRelease ()
	package:RemoveRelease (previousPackageRelease)
	package:AddRelease (packageRelease)
	
	return packageRelease, dependencySet, previousPackageRelease
end
