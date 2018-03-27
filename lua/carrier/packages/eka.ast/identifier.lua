local self = {}
AST.Identifier = Class (self)

function self:ctor (name)
	self.Name = name
end

function self:GetName ()
	return self.Name
end

function self:SetName (name)
	self.Name = name
end
