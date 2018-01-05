local self = {}
AST.BinaryOperator = Class (self, AST.IBinaryOperator)

function self:ctor (symbol, precedence, f)
	self.Function   = f
	self.Symbol     = symbol
	self.Precedence = precedence
end

-- IOperator
function self:GetAssociativity ()
	return AST.Associativity.Associative
end

function self:GetPrecedence ()
	return self.Precedence
end

function self:GetSymbol ()
	return self.Symbol
end

-- IBinaryOperator
function self:Evaluate (left, right)
	return self.Function (left, right)
end
