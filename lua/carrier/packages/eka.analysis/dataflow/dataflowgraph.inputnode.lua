local self = {}
Analysis.DataFlowGraph.InputNode = Class (self, Analysis.DataFlowGraph.ExternalNode)

function self:ctor ()
end

-- Node
function self:EvaluateConstant (arguments, cachingEvaluator)
	return arguments [self] and cachingEvaluator (arguments [self], arguments) or nil
end

function self:GetDependencies (out)
	return out or {}
end
