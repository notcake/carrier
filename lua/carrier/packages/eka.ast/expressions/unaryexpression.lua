local self = {}
AST.UnaryExpression = Class (self, AST.Expression)

function self:ctor (operator, innerExpression)
	self.Operator        = operator
	
	self.InnerExpression = innerExpression
end

-- Node
function self:GetChildEnumerator ()
	return SingleValueEnumerator (self.InnerExpression)
end

function self:ToString ()
	local innerExpression = self.InnerExpression:ToString ()
	if self.InnerExpression:IsOperatorExpression () and
	   self.InnerExpression:GetOperator ():GetPrecedence () >= self.Operator:GetPrecedence () and
	   self.InnerExpression:GetOperator ():GetAssociativity () ~= self.Operator:GetAssociativity () then
		innerExpression = "(" .. innerExpression .. ")"
	end
	
	if self.Operator:GetAssociativity () == AST.Associativity.Left then
		return innerExpression .. self.Operator:GetSymbol ()
	elseif self.Operator:GetAssociativity () == AST.Associativity.Right then
		return self.Operator:GetSymbol () .. innerExpression
	end
end

-- Expression
function self:EvaluateConstant (cachingEvaluator)
	local inner = cachingEvaluator (self.InnerExpression)
	return inner and self.Operator:Evaluate (inner) or nil
end

function self:IsOperatorExpression ()
	return true
end

-- UnaryExpression
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
