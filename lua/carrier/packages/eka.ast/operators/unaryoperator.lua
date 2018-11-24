local self = {}
AST.UnaryOperator = Class(self, AST.IUnaryOperator)

function self:ctor(symbol, precedence, f)
	self.Function   = f
	self.Symbol     = symbol
	self.Precedence = precedence
end

-- IOperator
function self:GetPrecedence()
	return self.Precedence
end

function self:GetSymbol()
	return self.Symbol
end

-- IUnaryOperator
function self:Evaluate(inner)
	return self.Function(inner)
end
