local self = {}
Analysis.ControlFlowGraph.ILink = Interface(self)

function self:ctor(sourceBlock, destinationBlock)
	self.SourceBlock      = sourceBlock
	self.DestinationBlock = destinationBlock
end

function self:GetSourceBlock()
	return self.SourceBlock
end

function self:GetDestinationBlock()
	return self.DestinationBlock
end
