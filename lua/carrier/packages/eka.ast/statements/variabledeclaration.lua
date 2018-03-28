local self = {}
AST.Statements.VariableDeclaration = Class (self, AST.Statement)

function self:ctor (identifier, expression)
	self.Identifier = identifier
	self.Expression = expression
end

-- Node
function self:GetChildEnumerator ()
	coroutine.yield (self.Identifier)
	coroutine.yield (self.Expression)
end
self.GetChildEnumerator = YieldEnumeratorFactory (self.GetChildEnumerator)

function self:ToString ()
	return "var " .. self.Identifier:ToString () .. " = " .. self.Expression:ToString () .. ";"
end

-- VariableDeclaration
function self:GetIdentifier ()
	return self.Identifier
end

function self:GetExpression ()
	return self.Expression
end

function self:SetIdentifier (identifier)
	self.Identifier = identifier
end

function self:SetExpression (expression)
	self.Expression = expression
end
