local self = {}
Analysis.DataFlowGraph.LeftUnaryOperatorNode = Class (self, Analysis.DataFlowGraph.UnaryOperatorNode)

function self:ctor (innerDataFlowNode, operator)
end

-- Node
function self:ToString ()
	return self.Operator:GetSymbol () ..  self.InnerDataFlowNode:ToString ()
end
