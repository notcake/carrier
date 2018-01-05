local self = {}
AST.BinaryOperator = Class (self, AST.IBinaryOperator)

function self:ctor (symbol, precedence, f, commutative)
	self.Function    = f
	self.Symbol      = symbol
	self.Precedence  = precedence
	self.Commutative = commutative or false
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

function self:IsCommutative ()
	return self.Commutative
end
