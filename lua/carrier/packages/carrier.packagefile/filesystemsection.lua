local self = {}
PackageFile.FileSystemSection = Class (self, PackageFile.Section)

function PackageFile.FileSystemSection.Deserialize (streamReader)
	local section = PackageFile.FileSystemSection ()
	section:SetDataLength (streamReader:UInt32 ())
	
	section.FileCount = streamReader:UInt32 ()
	for i = 1, section.FileCount do
		local file = PackageFile.FileSystemFile.Deserialize (streamReader)
		section.FilesByPath [file:GetPath ()] = file
		section.Files [#section.Files + 1] = file
	end
	
	return section
end

function self:ctor ()
	self:SetName ("code")
	
	self.FileCount = 0
	self.FilesByPath = {}
	self.Files = {}
end

-- ISerializable
function self:Serialize (streamWriter)
	PackageFile.Section:GetMethodTable ().Serialize (self, streamWriter)
	streamWriter:UInt32 (self.FileCount)
	
	for file in self:GetFileEnumerator () do
		file:Serialize (streamWriter)
	end
end

-- Section
function self:Update ()
	local dataLength = 4
	
	for file in self:GetFileEnumerator () do
		dataLength = dataLength + file:GetSerializationLength ()
	end
	
	self:SetDataLength (dataLength)
end

-- FileSystemSection
function self:AddFile (file)
	self.FilesByPath [file:GetPath ()] = file
	self.Files [#self.Files + 1] = file
	self.FileCount = self.FileCount + 1
end

function self:GetFile (indexOrPath)
	return self.FilesByPath [indexOrPath] or self.Files [indexOrPath]
end

function self:GetFileCount ()
	return self.FileCount
end

function self:GetFileEnumerator ()
	return ArrayEnumerator (self.Files)
end
