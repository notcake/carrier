local self = {}
AST.Expressions.Assignment = Class (self, AST.Expression)

function self:ctor (accessExpression, expression)
	self.AccessExpression = accessExpression
	self.Expression       = expression
end

-- Node
self.ChildrenFieldNames = { "AccessExpression", "Expression" }

function self:ToString ()
	return self.AccessExpression:ToString () .. " = " .. self.Expression:ToString ()
end

-- Assignment
function self:GetAccessExpression ()
	return self.AccessExpression
end

function self:GetExpression ()
	return self.Expression
end

function self:SetAccessExpression (accessExpression)
	self.AccessExpression = accessExpression
end

function self:SetExpression (expression)
	self.Expression = expression
end
