local self = {}
AST.BinaryExpression = Class (self, AST.Expression)

function self:ctor (operator, leftExpression, rightExpression)
	self.Operator        = operator
	
	self.LeftExpression  = leftExpression
	self.RightExpression = rightExpression
end

function self:GetOperator ()
	return self.Operator
end

function self:SetOperator (operator)
	self.Operator = operator
end

function self:GetLeftExpression ()
	return self.LeftExpression
end

function self:GetRightExpression ()
	return self.RightExpression
end

function self:SetLeftExpression (leftExpression)
	self.LeftExpression = leftExpression
end

function self:SetRightExpression (rightExpression)
	self.RightExpression = rightExpression
end
