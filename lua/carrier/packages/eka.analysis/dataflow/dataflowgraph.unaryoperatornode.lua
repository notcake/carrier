local self = {}
Analysis.DataFlowGraph.UnaryOperatorNode = Class (self, Analysis.DataFlowGraph.Node)

function self:ctor (innerDataFlowNode, operator)
	self.InnerDataFlowNode = innerDataFlowNode
	self.Operator = operator
end

-- Node
function self:EvaluateConstant (arguments, cachingEvaluator)
	local inner = cachingEvaluator (self.InnerDataFlowNode, arguments)
	if inner then
		return self.Operator:Evaluate (inner)
	end
	return nil
end

-- UnaryOperatorNode
function self:GetInnerDataFlowNode ()
	return self.InnerDataFlowNode
end
