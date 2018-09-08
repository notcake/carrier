local self = {}
AST.Statements.VariableDeclaration = Class (self, AST.Statement)

function self:ctor (identifier, expression)
	self.Identifier = identifier
	self.Expression = expression
end

-- Node
self.ChildrenFieldNames = { "Identifier", "Expression" }

function self:ToString ()
	if self.Expression then
		return "var " .. self.Identifier:ToString () .. " = " .. self.Expression:ToString () .. ";"
	else
		return "var " .. self.Identifier:ToString () .. ";"
	end
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
