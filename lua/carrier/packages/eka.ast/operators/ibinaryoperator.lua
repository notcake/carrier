local self = {}
AST.IBinaryOperator = Interface(self, AST.IOperator)

function self:ctor()
end

function self:Evaluate(left, right)
	Error("IBinaryOperator:Evaluate : Not implemented.")
end

function self:IsAssociative()
	Error("IBinaryOperator:IsAssociative : Not implemented.")
end

function self:IsCommutative()
	Error("IBinaryOperator:IsCommutative : Not implemented.")
end
