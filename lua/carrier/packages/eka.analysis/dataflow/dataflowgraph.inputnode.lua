local self = {}
Analysis.DataFlowGraph.InputNode = Class (self, Analysis.DataFlowGraph.ExternalNode)

function self:ctor (address)
end

-- Node
-- Expression
function self:EvaluateConstant (inputSubstitutionMap, cachingEvaluator)
	return inputSubstitutionMap [self] and cachingEvaluator (inputSubstitutionMap [self], inputSubstitutionMap) or nil
end

-- IO
function self:IsInputNode ()
	return true
end
