local self = {}
AST.Expressions.VariableAccess = Class (self, AST.Expression)

function self:ctor (identifier)
	self.Identifier = identifier
end

-- Node
self.ChildrenFieldNames = { "Identifier" }

function self:ToString ()
	return self.Identifier:ToString ()
end

-- VariableAccess
function self:GetIdentifier ()
	return self.Identifier
end

function self:SetIdentifier (identifier)
	self.Identifier = identifier
end
