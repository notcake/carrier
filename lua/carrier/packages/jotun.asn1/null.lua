local self = {}
Asn1.Null = Class(self)

function self:ctor()
end

function self:ToString()
	return "NULL"
end

function self:__call()
	return self
end

function self:__tostring()
	return self:ToString()
end

Asn1.Null = Asn1.Null()
