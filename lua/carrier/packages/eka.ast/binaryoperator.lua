local self = {}
AST.BinaryOperator = Class (self, AST.IBinaryOperator)

function self:ctor (symbol, f)
	self.Function = f
	self.Symbol   = symbol
end

function self:Evaluate (left, right)
	return self.Function (left, right)
end

function self:GetSymbol ()
	return self.Symbol
end
