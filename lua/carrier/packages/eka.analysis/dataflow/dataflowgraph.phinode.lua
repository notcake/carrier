local self = {}
Analysis.DataFlowGraph.PhiNode = Class (self)

function Analysis.DataFlowGraph.PhiNode.Union (node1, value1, node2, value2)
	local phi = Analysis.DataFlowGraph.PhiNode ()
	phi:Add (node1, value1)
	phi:Add (node2, value2)
	return phi
end

function Analysis.DataFlowGraph.PhiNode.Optional (node, value)
	local phi = Analysis.DataFlowGraph.PhiNode ()
	phi:Add (nil, nil)
	phi:Add (node, value)
	return phi
end

function self:ctor ()
	self.Address = nil
	
	self.InputNode  = false
	self.OutputNode = false
	
	self.Optional = false
	self.DataFlowNodes = {}
end

-- Node
function self:GetDependencies (out)
	local out = out or {}
	for dataFlowNode in pairs (self.DataFlowNodes) do
		out [#out + 1] = dataFlowNode
	end
	return out
end

-- IO
function self:IsInputNode ()
	return self.InputNode
end

function self:IsOutputNode ()
	return self.OutputNode
end

function self:GetAliasingGroup ()
	return Analysis.AliasingGroup.Other
end

function self:ToString ()
	local values = {}
	if self:IsOptional () then
		values [#values + 1] = "nil"
	end
	for node, _ in self:GetNodeEnumerator () do
		values [#values + 1] = node:ToString ()
	end
	return "Φ(" .. table.concat (values) .. ")"
end

-- Phi
function self:IsPhiNode ()
	return true
end

-- PhiNode
function self:GetNodeEnumerator ()
	return KeyValueEnumerator (self.DataFlowNodes)
end

function self:IsOptional ()
	return self.Optional
end

-- Internal
function self:Add (node, value)
	if node then
		self.InputNode  = self.InputNode  or node:IsInputNode  ()
		self.OutputNode = self.OutputNode or node:IsOutputNode ()
		
		if node:IsPhiNode () then
			self.Optional = self.Optional or node:IsOptional ()
			for node, value in node:GetNodeEnumerator () do
				self.DataFlowNodes [node] = value
			end
		else
			self.DataFlowNodes [node] = value
		end
	else
		self.Optional = true
	end
end
