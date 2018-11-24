local self = {}
AST.RightUnaryOperator = Class(self, AST.UnaryOperator)

function self:ctor(symbol, precedence, f)
end

-- IOperator
function self:GetAssociativity()
	return AST.Associativity.Left
end
