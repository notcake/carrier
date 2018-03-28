local self = {}
AST.Expressions.Assignment = Class (self, AST.Expression)

function self:ctor (accessExpression, expression)
	self.AccessExpression = accessExpression
	self.Expression       = expression
end

-- Node
function self:GetChildEnumerator ()
	coroutine.yield (self.AccessExpression)
	coroutine.yield (self.Expression)
end
self.GetChildEnumerator = YieldEnumeratorFactory (self.GetChildEnumerator)

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
