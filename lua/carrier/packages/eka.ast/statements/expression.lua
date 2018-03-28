local self = {}
AST.Statements.Expression = Class (self, AST.Statement)

function self:ctor (expression)
	self.Expression = expression
end

-- Node
function self:GetChildEnumerator ()
	return SingleValueEnumerator (self.Expression)
end

function self:ToString ()
	return self.Expression:ToString () .. ";"
end

-- Expression
function self:GetExpression ()
	return self.Expression
end

function self:SetExpression (expression)
	self.Expression = expression
end
