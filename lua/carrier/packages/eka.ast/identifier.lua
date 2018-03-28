local self = {}
AST.Identifier = Class (self, AST.Node)

function self:ctor (name)
	self.Name = name
end

-- Node
function self:ToString ()
	return self.Name
end

-- Identifier
function self:GetName ()
	return self.Name
end

function self:SetName (name)
	self.Name = name
end
