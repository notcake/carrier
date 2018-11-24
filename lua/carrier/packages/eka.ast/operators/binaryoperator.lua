local self = {}
AST.BinaryOperator = Class(self, AST.IBinaryOperator)

function self:ctor(symbol, precedence, associativity, commutative, f)
	self.Function      = f
	self.Symbol        = symbol
	self.Precedence    = precedence
	self.Associativity = associativity
	self.Commutative   = commutative or false
end

-- IOperator
function self:GetAssociativity()
	return self.Associativity
end

function self:GetPrecedence()
	return self.Precedence
end

function self:GetSymbol()
	return self.Symbol
end

-- IBinaryOperator
function self:Evaluate(left, right)
	return self.Function(left, right)
end

function self:IsAssociative()
	return self.Associativity == AST.Associativity.Associative
end

function self:IsCommutative()
	return self.Commutative
end
