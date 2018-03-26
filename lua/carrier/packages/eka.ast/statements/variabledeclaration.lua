local self = {}
AST.VariableDeclaration = Class (self, AST.Statement)

function self:ctor (name, expression)
	self.Name       = name
	self.Expression = expression
end

-- VariableDeclaration
function self:GetName ()
	return self.Name
end

function self:GetExpression ()
	return self.Expression
end

function self:SetName (name)
	self.Name = name
end

function self:SetExpression (expression)
	self.Expression = expression
end
