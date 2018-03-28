local self = {}
Analysis.ControlFlowGraph.Block = Class (self)

function self:ctor (startAddress)
	self.StartAddress  = startAddress
	self.Size          = 0
	
	self.BranchAddress               = 0
	self.BranchType                  = nil
	self.BranchConditionExpression   = nil
	self.BranchDestinationExpression = nil
	
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

function self:GetBranchConditionExpression ()
	return self.BranchConditionExpression
end

function self:GetBranchDestinationExpression ()
	return self.BranchDestinationExpression
end

function self:SetBranchAddress (branchAddress)
	self.BranchAddress = branchAddress
end

function self:SetBranchType (branchType)
	self.BranchType = branchType
end

function self:SetBranchConditionExpression (branchConditionExpression)
	self.BranchConditionExpression = branchConditionExpression
end

function self:SetBranchDestinationExpression (branchDestinationExpression)
	self.BranchDestinationExpression = branchDestinationExpression
end
