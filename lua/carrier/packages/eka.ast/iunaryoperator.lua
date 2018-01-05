local self = {}
AST.IUnaryOperator = Interface (self, AST.IOperator)

function self:ctor ()
end

function self:Evaluate (inner)
	Error ("IUnaryOperator:Evaluate : Not implemented.")
end
