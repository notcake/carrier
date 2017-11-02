local self = {}
AST.UnaryOperator = Class (self, AST.IUnaryOperator)

function self:ctor (symbol, f)
	self.Function = f
	self.Symbol   = symbol
end

function self:Evaluate (inner)
	return self.Function (inner)
end

function self:GetSymbol ()
	return self.Symbol
end
