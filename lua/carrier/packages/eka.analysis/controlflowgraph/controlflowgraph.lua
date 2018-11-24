local self = {}
Analysis.ControlFlowGraph = Class(self)

function self:ctor(link)
	self.Link = link or Analysis.ControlFlowGraph.Link
	
	self.BlocksByStartAddress = {}
	
	self.BlockLocks        = {}
	self.BlockPredecessors = {}
	self.BlockSuccessors   = {}
end

function self:AddBlock(block)
	self.BlocksByStartAddress[block:GetStartAddress()] = block
end

function self:GetBlock(startAddress)
	return self.BlocksByStartAddress[startAddress]
end

function self:GetBlockPredecessorEnumerator(block)
	if not self.BlockPredecessors[block] then return NullEnumerator() end
	return KeyValueEnumerator(self.BlockPredecessors[block])
end

function self:GetBlockSuccessorEnumerator(block)
	if not self.BlockSuccessors[block] then return NullEnumerator() end
	return KeyValueEnumerator(self.BlockSuccessors[block])
end

function self:IsBlockStart(startAddress)
	return self:GetBlock(startAddress) ~= nil
end

function self:LockBlockLinks(block)
	self.BlockLocks[block] = self.BlockLocks[block] or 0
	self.BlockLocks[block] = self.BlockLocks[block] + 1
end

function self:UnlockBlockLinks(block)
	self.BlockLocks[block] = self.BlockLocks[block] - 1
	if not self.BlockLocks[block] then
		self.BlockLocks[block] = nil
	end
end

function self:AddLink(sourceBlock, destinationBlock)
	self.BlockPredecessors[destinationBlock] = self.BlockPredecessors[destinationBlock] or {}
	self.BlockSuccessors  [sourceBlock]      = self.BlockSuccessors  [sourceBlock]      or {}
	
	if self.BlockSuccessors[sourceBlock] [destinationBlock] then
		return self.BlockSuccessors[sourceBlock] [destinationBlock]
	else
		local link = self.Link(sourceBlock, destinationBlock)
		
		if self.BlockLocks[destinationBlock] then
			self.BlockPredecessors[destinationBlock] = Map.Copy(self.BlockPredecessors[destinationBlock])
		end
		if self.BlockLocks[sourceBlock] then
			self.BlockSuccessors[sourceBlock] = Map.Copy(self.BlockSuccessors[sourceBlock])
		end

		self.BlockPredecessors[destinationBlock] [sourceBlock]      = link
		self.BlockSuccessors  [sourceBlock]     [destinationBlock] = link
		
		return link
	end
end

function self:GetLink(sourceBlock, destinationBlock)
	if not self.BlockSuccessors[sourceBlock] then return nil end
	return self.BlockSuccessors[sourceBlock] [destinationBlock]
end

function self:RemoveLink(sourceBlock, destinationBlock)
	if not destinationBlock then
		local link = sourceBlock
		sourceBlock, destinationBlock = link:GetSourceBlock(), link:GetDestinationBlock()
	end
	
	if not self.BlockSuccessors[sourceBlock] then return end
	
	self.BlockPredecessors[destinationBlock] [sourceBlock]      = nil
	self.BlockSuccessors  [sourceBlock]     [destinationBlock] = nil
end
