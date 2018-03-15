local self = {}
Analysis.DataFlowGraph.InputNode = Class (self, Analysis.DataFlowGraph.ExternalNode)

function self:ctor (address)
end

-- Node
-- IO
function self:IsInputNode ()
	return true
end
