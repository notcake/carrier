local self = {}
Analysis.ControlFlowGraph.Block = Class (self)

function self:ctor (startAddress)
	self.StartAddress  = startAddress
	self.Size          = 0
	
	self.BranchAddress                 = 0
	self.BranchType                    = nil
	self.BranchConditionDataFlowNode   = nil
	self.BranchDestinationDataFlowNode = nil
	
	self.DataFlowGraph = Analysis.DataFlowGraph ()
end

-- Address span
function self:GetStartAddress ()
	return self.StartAddress
end

function self:GetEndAddress ()
	return self.StartAddress + self.Size
end

function self:GetSize ()
	return self.Size
end

function self:SetSize (size)
	self.Size = size
end

-- Data flow graph
function self:GetDataFlowGraph ()
	return self.DataFlowGraph
end

-- Branch
function self:GetBranchAddress ()
	return self.BranchAddress
end

function self:GetBranchType ()
	return self.BranchType
end

function self:GetBranchConditionDataFlowNode ()
	return self.BranchConditionDataFlowNode
end

function self:GetBranchDestinationDataFlowNode ()
	return self.BranchDestinationDataFlowNode
end

function self:SetBranchAddress (branchAddress)
	self.BranchAddress = branchAddress
end

function self:SetBranchType (branchType)
	self.BranchType = branchType
end

function self:SetBranchConditionDataFlowNode (branchConditionDataFlowNode)
	self.BranchConditionDataFlowNode = branchConditionDataFlowNode
end

function self:SetBranchDestinationDataFlowNode (branchDestinationDataFlowNode)
	self.BranchDestinationDataFlowNode = branchDestinationDataFlowNode
end
