local self = {}
AST.UnaryExpression = Class (self, AST.Expression)

function self:ctor (operator, innerExpression)
	self.Operator        = operator
	
	self.InnerExpression = innerExpression
end

function self:GetOperator ()
	return self.Operator
end

function self:SetOperator (operator)
	self.Operator = operator
end

function self:GetInnerExpression ()
	return self.InnerExpression
end

function self:SetInnerExpression (innerExpression)
	self.InnerExpression = innerExpression
end
