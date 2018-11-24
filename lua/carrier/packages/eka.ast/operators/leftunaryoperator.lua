local self = {}
AST.LeftUnaryOperator = Class(self, AST.UnaryOperator)

function self:ctor(symbol, precedence, f)
end

-- IOperator
function self:GetAssociativity()
	return AST.Associativity.Right
end
