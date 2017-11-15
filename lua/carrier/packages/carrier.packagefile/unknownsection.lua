local self = {}
PackageFile.UnknownSection = Class (self, PackageFile.Section)

function PackageFile.UnknownSection.Deserialize (streamReader, name)
	local section = PackageFile.UnknownSection (name)
	section:SetDataLength (streamReader:UInt32 ())
	
	section.Data = streamReader:Bytes (section:GetDataLength ())
	
	return section
end

function self:ctor (name)
	self.Name = name
	self.Data = ""
end

-- ISerializable
function self:Serialize (streamWriter)
	PackageFile.Section:GetMethodTable ().Serialize (self, streamWriter)
	streamWriter:Bytes (self.Data)
end

-- Section
function self:Update ()
	self:SetDataLength (#self.Data)
end

-- UnknownSection
function self:GetData ()
	return self.Data
end

function self:SetData (data)
	self.Data = data
	self:SetDataLength (#self.Data)
end
