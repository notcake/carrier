local self = {}
Carrier.PackageRelease = Class (self, Carrier.IPackageRelease, ISerializable)

function Carrier.PackageRelease.FromJson (info, name)
	local version = info.version
	local packageRelease = Carrier.PackageRelease (name, version)
	return packageRelease:FromJson (info)
end

function self:ctor (name, version)
	self.Version    = version
	self.Timestamp  = 0
	
	self.Deprecated = false
	
	self.Size       = 0
	self.FileName   = nil
end

-- ISerializable
function self:Serialize (streamWriter)
	streamWriter:UInt64  (self.Timestamp)
	streamWriter:Boolean (self.Deprecated)
	streamWriter:UInt64  (self.Size)
	
	streamWriter:UInt32 (self.DependencyCount)
	for dependencyName, dependencyVersion in self:GetDependencyEnumerator () do
		streamWriter:StringN8 (dependencyName)
		streamWriter:StringN8 (dependencyVersion)
	end
end

function self:Deserialize (streamReader)
	self.Timestamp  = streamReader:UInt64  ()
	self.Deprecated = streamReader:Boolean ()
	self.Size       = streamReader:UInt64  ()
	
	local dependencyCount = streamReader:UInt32 ()
	for i = 1, dependencyCount do
		local dependencyName    = streamReader:StringN8 ()
		local dependencyVersion = streamReader:StringN8 ()
		self:AddDependency (dependencyName, dependencyVersion)
	end
	
	self:UpdateFileName ()
end

-- IPackageRelease
function self:GetVersion ()
	return self.Version
end

function self:GetTimestamp ()
	return self.Timestamp
end

function self:IsDeprecated ()
	return self.Deprecated
end

function self:IsDeveloper ()
	return false
end

-- Loading
function self:IsAvailable ()
	return file.Exists (Carrier.Packages.CacheDirectory .. "/" .. self.FileName, "DATA")
end

function self:Load (environment)
	local inputStream = IO.FileInputStream.FromPath (Carrier.Packages.CacheDirectory .. "/" .. self.FileName, "DATA")
	if not inputStream then
		Carrier.Warning ("Package file for " .. self.Name .. " " .. self.Version .. " missing!")
		return
	end
	
	local packageFile = PackageFile.Deserialize (inputStream, PublicKey.Exponent, PublicKey.Modulus)
	inputStream:Close ()
	
	if packageFile:GetName () ~= self.Name or
	   packageFile:GetVersion () ~= self.Version then
		Carrier.Warning ("Package file for " .. self.Name .. " " .. self.Version .. " has incorrect name or version (" .. packageFile:GetName () .. " " .. packageFile:GetVersion () .. ")!")
		file.Delete (Carrier.Packages.CacheDirectory .. "/" .. self.FileName)
		return
	end
	
	if not packageFile:GetSection ("code") then
		Carrier.Warning ("Package file " .. self.Name .. " " .. self.Version .. " has no code section!")
		return
	elseif not packageFile:GetSection ("code"):IsVerified () then
		Carrier.Warning ("Package file " .. self.Name .. " " .. self.Version .. " has invalid signature for code section!")
		return
	elseif not packageFile:GetSection ("luahashes") then
		Carrier.Warning ("Package file " .. self.Name .. " " .. self.Version .. " has no Lua hashes section!")
		return
	elseif not packageFile:GetSection ("luahashes"):IsVerified () then
		Carrier.Warning ("Package file " .. self.Name .. " " .. self.Version .. " has invalid signature for Lua hashes section!")
		return
	end
	
	local codeSection = packageFile:GetSection ("code")
	environment.loadfile = function (path)
		local file = codeSection:GetFile (path)
		if not file then
			Carrier.Warning (self.Name .. " " .. self.Version .. ": " .. path .. " not found.")
			return nil, nil
		end
		
		local f = CompileString (file:GetData (), path, false)
		
		if type (f) == "string" then
			Carrier.Warning (self.Name .. " " .. self.Version .. ": " .. f)
			return nil, nil
		end
		
		setfenv (f, environment)
		return f
	end
	
	-- ctor
	local f = environment.loadfile ("_ctor.lua")
	if not f then
		environment.loadfile = nil
		environment.include  = nil
		return nil, nil
	end
	
	-- dtor
	local file = codeSection:GetFile ("_dtor.lua")
	local destructor = file and environment.loadfile ("_dtor.lua")
	
	local success, exports = xpcall (f, debug.traceback)
	environment.loadfile = nil
	environment.include  = nil
	if not success then
		Carrier.Warning (exports)
		return nil, destructor
	end
	
	return exports, destructor
end

-- PackageRelease
function self:GetSize ()
	return self.Size
end

function self:GetFileName ()
	return self.FileName
end

function self:SetDeprecated (deprecated)
	self.Deprecated = deprecated
end

function self:FromJson (info)
	self.Timestamp = info.timestamp
	self.Size      = info.size
	
	for dependencyName, dependencyVersion in pairs (info.dependencies) do
		self:AddDependency (dependencyName, dependencyVersion)
	end
	
	self:UpdateFileName ()
	
	return self
end

-- Internal
function self:UpdateFileName ()
	self.FileName = "release-" .. Carrier.ToFileName (self.Name) .. "-" .. string.format ("%08x", self.Timestamp) .. "-" .. Carrier.ToFileName (self.Version) .. ".dat"
end
