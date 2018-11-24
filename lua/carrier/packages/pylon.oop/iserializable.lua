local self = {}
OOP.ISerializable = OOP.Interface(self)

function self:ctor()
end

function self:Serialize(streamWriter)
	Error("ISerializable:Serialize : Not implemented.")
end

function self:Deserialize(streamReader)
	Error("ISerializable:Deserialize : Not implemented.")
end
