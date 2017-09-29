local self = {}
Analysis.DataFlowGraph.Node = Class (self)

function self:ctor ()
end

function self:EvaluateConstant ()
	return nil
end

function self:IsConstant ()
	return false
end

function self:ToString ()
	return "{ DataFlowGraph.Node }"
end
