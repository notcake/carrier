local self = {}
AST.Expression = Class (self, AST.Node)

function self:ctor ()
end

-- Expression
function self:EvaluateConstant (cachingEvaluator)
	return nil
end

function self:IsOperatorExpression ()
	return false
end

function self:IsPhi ()
	return false
end
