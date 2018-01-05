local self = {}
Analysis.DataFlowGraph.Node = Class (self)

function self:ctor (address)
	self.Address = address
end

function self:EvaluateConstant (arguments, cachingEvaluator)
	return nil
end

function self:GetAddress ()
	return self.Address
end

function self:GetDependencies (out)
	return out or {}
end

function self:GetOperator ()
	return nil
end

function self:ToString ()
	return "{ DataFlowGraph.Node }"
end
