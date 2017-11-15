local self = {}
PackageFile.LuaHashesSection = Class (self, PackageFile.Section)

function PackageFile.LuaHashesSection.Deserialize (streamReader)
	local section = PackageFile.LuaHashesSection ()
	section:SetDataLength (streamReader:UInt32 ())
	
	section.LuaFileCount = streamReader:UInt32 ()
	for i = 1, section.FileCount do
		local luaFile = Verification.LuaFile.Deserialize (streamReader, true)
		section.LuaFilesByPath [file:GetPath ()] = luaFile
		section.LuaFiles [#section.Files + 1] = luaFile
	end
	
	return section
end

function self:ctor ()
	self:SetName ("luahashes")
	
	self.LuaFileCount = 0
	self.LuaFilesByPath = {}
	self.LuaFiles = {}
end

-- ISerializable
function self:Serialize (streamWriter)
	PackageFile.Section:GetMethodTable ().Serialize (self, streamWriter)
	streamWriter:UInt32 (self.LuaFileCount)
	
	for luaFile in self:GetLuaFileEnumerator () do
		luaFile:Serialize (streamWriter)
	end
end

-- Section
function self:Update ()
	local dataLength = 4
	
	for luaFile in self:GetLuaFileEnumerator () do
		dataLength = dataLength + luaFile:GetSerializationLength ()
	end
	
	self:SetDataLength (dataLength)
end

-- LuaHashesSection
function self:AddLuaFile (luaFile)
	self.LuaFilesByPath [luaFile:GetPath ()] = luaFile
	self.LuaFiles [#self.LuaFiles + 1] = luaFile
	self.LuaFileCount = self.LuaFileCount + 1
end

function self:GetLuaFile (indexOrPath)
	return self.LuaFilesByPath [indexOrPath] or self.LuaFiles [indexOrPath]
end

function self:GetLuaFileCount ()
	return self.LuaFileCount
end

function self:GetLuaFileEnumerator ()
	return ArrayEnumerator (self.LuaFiles)
end
