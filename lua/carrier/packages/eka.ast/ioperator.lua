local self = {}
AST.IOperator = Interface (self)

function self:ctor ()
end

function self:GetAssociativity ()
	Error ("IOperator:GetAssociativity : Not implemented.")
end

function self:GetPrecedence ()
	Error ("IOperator:GetPrecedence : Not implemented.")
end

function self:GetSymbol ()
	Error ("IOperator:GetSymbol : Not implemented.")
end
