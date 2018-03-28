local self = {}
AST.Expressions.VariableAccess = Class (self, AST.Expression)

function self:ctor (identifier)
	self.Identifier = identifier
end

-- Node
function self:GetChildEnumerator ()
	return SingleValueEnumerator (self.Identifier)
end

function self:ToString ()
	return self.Identifier:ToString ()
end
