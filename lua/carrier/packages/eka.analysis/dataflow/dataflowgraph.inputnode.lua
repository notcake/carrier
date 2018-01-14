local self = {}
Analysis.DataFlowGraph.InputNode = Class (self, Analysis.DataFlowGraph.ExternalNode)

function self:ctor (address)
end

-- Node
function self:EvaluateConstant (inputSubstitutionMap, cachingEvaluator)
	return inputSubstitutionMap [self] and cachingEvaluator (inputSubstitutionMap [self], inputSubstitutionMap) or nil
end

function self:GetDependencies (out)
	return out or {}
end
