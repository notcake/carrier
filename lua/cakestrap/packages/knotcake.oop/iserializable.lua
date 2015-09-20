local self = {}
OOP.ISerializable = OOP.Class (self)

function self:ctor ()
end

function self:Serialize (streamWriter)
	OOP.Error ("ISerializable:Serialize : Not implemented.")
end

function self:Deserialize (streamReader)
	OOP.Error ("ISerializable:Deserialize : Not implemented.")
end
