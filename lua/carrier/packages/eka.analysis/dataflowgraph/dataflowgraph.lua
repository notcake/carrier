local self = {}
Analysis.DataFlowGraph = Class (self)

function self:ctor ()
	self.InputNodeSet    = {}
	self.OutputNodeSet   = {}
	self.NodeSet         = {}
	
	self.InputNodeCount  = 0
	self.OutputNodeCount = 0
	self.NodeCount       = 0
end

function self:AddNode (node)
	if self.NodeSet [node] then return end
	self.NodeSet [node] = true
	self.NodeCount = self.NodeCount + 1
end

function self:AddInputNode (node)
	if self.InputNodeSet [node] then return end
	self.InputNodeSet [node] = true
	self.InputNodeCount = self.InputNodeCount + 1
	
	if self.NodeSet [node] then return end
	self.NodeSet [node] = true
	self.NodeCount = self.NodeCount + 1
end

function self:AddOutputNode (node)
	if self.OutputNodeSet [node] then return end
	self.OutputNodeSet [node] = true
	self.OutputNodeCount = self.OutputNodeCount + 1
	
	if self.NodeSet [node] then return end
	self.NodeSet [node] = true
	self.NodeCount = self.NodeCount + 1
end

function self:GetNodeCount ()
	return self.NodeCount
end

function self:GetInputNodeCount ()
	return self.InputNodeCount
end

function self:GetOutputNodeCount ()
	return self.OutputNodeCount
end

function self:GetInternalNodeCount ()
	return self.NodeCount - self.InputNodeCount - self.OutputNodeCount
end

function self:GetNodeEnumerator ()
	return KeyEnumerator (self.NodeSet)
end

function self:GetInputNodeEnumerator ()
	return KeyEnumerator (self.InputNodeSet)
end

function self:GetOutputNodeEnumerator ()
	return KeyEnumerator (self.OutputNodeSet)
end
