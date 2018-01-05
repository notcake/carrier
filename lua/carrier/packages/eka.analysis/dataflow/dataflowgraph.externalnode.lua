local self = {}
Analysis.DataFlowGraph.ExternalNode = Class (self, Analysis.DataFlowGraph.Node)

function self:ctor (address)
end

-- ExternalNode
function self:GetAliasingGroup ()
	Error ("ExternalNode:GetAliasingGroup : Not implemented.")
end
