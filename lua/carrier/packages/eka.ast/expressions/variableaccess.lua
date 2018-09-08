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
