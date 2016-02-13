local self = {}
OOP.ICloneable = OOP.Class (self)

function self:ctor ()
end

function self:Clone (clone)
	clone = clone or self:GetType ():CreateInstance ()
	
	clone:Copy (self)
	
	return clone
end

function self:Copy (source)
	OOP.Error ("ICloneable:Copy : Not implemented.")
end
