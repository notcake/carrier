local self = {}
PackageFile.FileSystemFile = Class (self, ISerializable)

function PackageFile.FileSystemFile.Deserialize (streamReader)
	local file = PackageFile.FileSystemFile ()
	file:Deserialize (streamReader)
	return file
end

function self:ctor ()
	self.Path = ""
	self.CRC32 = 0
	self.LastModificationTime = 0
	self.Size = 0
	self.Data = ""
end

-- ISerializable
function self:Serialize (streamWriter)
	streamWriter:StringN16 (self.Path)
	streamWriter:UInt32 (self.CRC32)
	streamWriter:UInt32 (self.LastModificationTime)
	streamWriter:UInt32 (self.Size)
	streamWriter:Bytes (self.Data)
end

function self:Deserialize (streamReader)
	self.Path                 = streamReader:StringN16 ()
	self.CRC32                = streamReader:UInt32 ()
	self.LastModificationTime = streamReader:UInt32 ()
	self.Size                 = streamReader:UInt32 ()
	self.Data                 = streamReader:Bytes (self.Size)
end

-- FileSystemFile
function self:GetPath ()
	return self.Path
end

function self:GetCRC32 ()
	return self.CRC32
end

function self:GetData ()
	return self.Data
end

function self:GetLastModificationTime ()
	return self.LastModificationTime
end

function self:GetSize ()
	return self.Size
end

function self:GetSerializationLength ()
	return 2 + #self.Path + 4 + 4 + 4 + self.Size
end
