local self = {}
PackageFile.FileSystemSection = Class(self, PackageFile.Section)
PackageFile.FileSystemSection.Name = "code"

function self:ctor()
	self.Files       = {}
	self.FilesByPath = {}
end

-- ISerializable
function self:Serialize(streamWriter)
	streamWriter:UInt32(#self.Files)
	for file in self:GetFileEnumerator() do
		file:Serialize(streamWriter)
	end
end

function self:Deserialize(streamReader)
	local fileCount = streamReader:UInt32()
	for i = 1, fileCount do
		local file = PackageFile.FileSystemFile.Deserialize(streamReader)
		self:AddFile(file)
	end
end

-- ISection
function self:GetName()
	return PackageFile.FileSystemSection.Name
end

-- FileSystemSection
function self:AddFile(file)
	self.Files[#self.Files + 1] = file
	self.FilesByPath[file:GetPath()] = file
end

function self:GetFile(indexOrPath)
	return self.FilesByPath[indexOrPath] or self.Files[indexOrPath]
end

function self:GetFileCount()
	return #self.Files
end

function self:GetFileEnumerator()
	return ArrayEnumerator(self.Files)
end
