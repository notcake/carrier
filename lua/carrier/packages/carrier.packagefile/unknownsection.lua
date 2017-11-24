local self = {}
PackageFile.UnknownSection = Class (self, PackageFile.ISection)

function self:ctor (name, data)
	self.Name = name
	self.Data = data or ""
end

-- ISerializable
function self:Serialize (streamWriter)
	streamWriter:Bytes (self.Data)
end

function self:Deserialize (streamReader)
end

-- Section
function self:GetName ()
	return self.Name
end

-- UnknownSection
function self:GetData ()
	return self.Data
end

function self:SetData (data)
	self.Data = data
end
