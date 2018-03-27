local self = {}
AST.Expression = Class (self, AST.Statement)

function self:ctor ()
end

-- Expression
function self:EvaluateConstant (cachingEvaluator)
	return nil
end

function self:IsOperatorExpression ()
	return false
end

function self:IsPhiExpression ()
	return false
end
