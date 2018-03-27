local self = {}
AST.BinaryExpression = Class (self, AST.Expression)

function self:ctor (operator, leftExpression, rightExpression)
	self.Operator        = operator
	
	self.LeftExpression  = leftExpression
	self.RightExpression = rightExpression
end

-- Node
function self:GetChildEnumerator ()
	coroutine.yield (self.LeftExpression)
	coroutine.yield (self.RightExpression)
end
self.GetChildEnumerator = YieldEnumeratorFactory (self.GetChildEnumerator)

function self:ToString ()
	local leftExpression  = self.LeftExpression:ToString ()
	local rightExpression = self.RightExpression:ToString ()
	if self.LeftExpression:IsOperatorExpression () and
	   (self.LeftExpression:GetOperator () ~= self.Operator or not self.Operator:IsAssociative ()) and
	   self.LeftExpression:GetOperator ():GetPrecedence () >= self.Operator:GetPrecedence () and
	   self.LeftExpression:GetOperator ():GetAssociativity () ~= AST.Associativity.Left then
		leftExpression = "(" .. leftExpression .. ")"
	end
	if self.RightExpression:IsOperatorExpression () and
	   (self.RightExpression:GetOperator () ~= self.Operator or not self.Operator:IsAssociative ()) and
	   self.RightExpression:GetOperator ():GetPrecedence () >= self.Operator:GetPrecedence () and
	   self.RightExpression:GetOperator ():GetAssociativity () ~= AST.Associativity.Right then
		rightExpression = "(" .. rightExpression .. ")"
	end
	
	return leftExpression .. " " .. self.Operator:GetSymbol () .. " " .. rightExpression
end

-- Expression
function self:EvaluateConstant (cachingEvaluator)
	local left  = cachingEvaluator (self.LeftExpression)
	local right = cachingEvaluator (self.RightExpression)
	return (left and right) and self.Operator:Evaluate (left, right) or nil
end

function self:IsOperatorExpression ()
	return true
end

-- BinaryExpression
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
