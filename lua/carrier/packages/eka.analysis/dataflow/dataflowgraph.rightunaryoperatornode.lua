local self = {}
Analysis.DataFlowGraph.RightUnaryOperatorNode = Class (self, Analysis.DataFlowGraph.UnaryOperatorNode)

function self:ctor (innerDataFlowNode, operator)
end

-- Node
function self:ToString ()
	return self.InnerDataFlowNode:ToString () .. self.Operator:GetSymbol ()
end
