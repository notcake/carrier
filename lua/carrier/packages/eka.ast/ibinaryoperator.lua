local self = {}
AST.IBinaryOperator = Interface (self, AST.IOperator)

function self:ctor ()
end

function self:Evaluate (left, right)
	Error ("IBinaryOperator:Evaluate : Not implemented.")
end
