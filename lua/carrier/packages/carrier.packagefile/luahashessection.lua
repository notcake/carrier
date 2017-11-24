local self = {}
PackageFile.LuaHashesSection = Class (self, PackageFile.Section)
PackageFile.LuaHashesSection.Name = "luahashes"

function self:ctor ()
	self.LuaFiles       = {}
	self.LuaFilesByPath = {}
end

-- ISerializable
function self:Serialize (streamWriter)
	streamWriter:UInt32 (#self.LuaFiles)
	for luaFile in self:GetLuaFileEnumerator () do
		luaFile:Serialize (streamWriter)
	end
end

function self:Deserialize (streamReader)
	local luaFileCount = streamReader:UInt32 ()
	for i = 1, luaFileCount do
		local luaFile = Verification.LuaFile.Deserialize (streamReader, true)
		self:AddLuaFile (luaFile)
	end
end

-- Section
function self:GetName ()
	return PackageFile.LuaHashesSection.Name
end

-- LuaHashesSection
function self:AddLuaFile (luaFile)
	self.LuaFiles [#self.LuaFiles + 1] = luaFile
	self.LuaFilesByPath [luaFile:GetPath ()] = luaFile
end

function self:GetLuaFile (indexOrPath)
	return self.LuaFilesByPath [indexOrPath] or self.LuaFiles [indexOrPath]
end

function self:GetLuaFileCount ()
	return #self.LuaFiles
end

function self:GetLuaFileEnumerator ()
	return ArrayEnumerator (self.LuaFiles)
end
