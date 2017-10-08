local self = {}
AST.IBinaryOperator = Interface (self)

function self:ctor ()
end

function self:Evaluate (left, right)
	Error ("IBinaryOperator:Evaluate : Not implemented.")
end

function self:GetSymbol ()
	Error ("IBinaryOperator:GetSymbol : Not implemented.")
end
