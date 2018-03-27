local self = {}
AST.AssignmentExpression = Class (self, AST.Expression)

function self:ctor (operator, accessExpression, expression)
	self.AccessExpression = accessExpression
	self.Expression       = expression
end

-- Node
function self:GetChildEnumerator ()
	coroutine.yield (self.AccessExpression)
	coroutine.yield (self.Expression)
end
self.GetChildEnumerator = YieldEnumeratorFactory (self.GetChildEnumerator)

-- AssignmentExpression
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
