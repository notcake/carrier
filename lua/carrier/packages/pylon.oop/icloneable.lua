local self = {}
OOP.ICloneable = OOP.Interface (self)

function self:ctor ()
end

function self:Clone (clone)
	clone = clone or self:GetType ():CreateInstance ()
	
	clone:Copy (self)
	
	return clone
end

function self:Copy (source)
	Error ("ICloneable:Copy : Not implemented.")
end
