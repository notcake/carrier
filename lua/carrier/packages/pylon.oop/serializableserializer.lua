local self = {}
OOP.SerializableSerializer = OOP.Class (self, OOP.ISerializer)

function self:ctor (class)
	self.Class = class
end

function self:__call ()
	return self:GetType ():CreateInstance (self.Class)
end

-- ISerializer
function self:Serialize (streamWriter, object)
	self.Class.Methods.Serialize (object, streamWriter)
end

function self:Deserialize (streamReader, object)
	object = object or self.Class ()
	
	return self.Class.Methods.Deserialize (object, streamReader)
end

-- SerializableSerializer
function self:GetSerializableType ()
	return self.Class
end
