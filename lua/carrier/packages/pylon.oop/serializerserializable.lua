local self = {}
OOP.SerializerSerializable = OOP.Class(self, OOP.ISerializable)

function self:ctor(serializer, object)
	self.Serializer = serializer
	self.Object     = object
end

function self:Serialize(streamWriter)
	self.Serializer:Serialize(streamWriter, self.Object)
end

function self:Deserialize(streamReader)
	return self.Serializer:Deserialize(streamReader, self.Object)
end

-- SerializerSerializable
function self:GetSerializer()
	return self.Serializable
end

function self:GetObject()
	return self.Object
end
