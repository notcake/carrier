local self = {}
AST.Expressions.Literal = Class(self, AST.Expression)

function self:ctor()
end

-- Expression
function self:IsConstant()
	return true
end
