local self = {}
PackageFile.Section = Class (self, ISerializable)

function self:ctor ()
	self.Name       = nil
	self.DataLength = 0
end

-- ISerializable
function self:Serialize (streamWriter)
	streamWriter:StringN8 (self.Name)
	streamWriter:UInt32 (self.DataLength)
end

-- Section
function self:GetName ()
	return self.Name
end

function self:GetDataLength ()
	return self.DataLength
end

function self:SetName (name)
	self.Name = name
end

function self:SetDataLength (dataLength)
	self.DataLength = dataLength
end

function self:Update ()
end
