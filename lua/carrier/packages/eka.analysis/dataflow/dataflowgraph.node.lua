local self = {}
Analysis.DataFlowGraph.Node = Class (self)

function self:ctor ()
end

function self:EvaluateConstant (arguments, cachingEvaluator)
	return nil
end

function self:GetDependencies (out)
	return out or {}
end

function self:ToString ()
	return "{ DataFlowGraph.Node }"
end
