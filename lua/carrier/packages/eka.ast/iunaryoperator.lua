local self = {}
AST.IUnaryOperator = Interface (self)

function self:ctor ()
end

function self:Evaluate (inner)
	Error ("IUnaryOperator:Evaluate : Not implemented.")
end

function self:GetSymbol ()
	Error ("IUnaryOperator:GetSymbol : Not implemented.")
end
