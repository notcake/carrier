local self = {}
OOP.ISerializer = OOP.Interface (self)

function self:ctor ()
end

function self:Serialize (streamWriter, object)
	Error ("ISerializer:Serialize : Not implemented.")
end

function self:Deserialize (streamReader, object)
	Error ("ISerializer:Deserialize : Not implemented.")
end
