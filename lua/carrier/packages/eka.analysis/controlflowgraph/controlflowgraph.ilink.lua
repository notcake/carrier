local self = {}
Analysis.ControlFlowGraph.ILink = Interface (self)

function self:ctor (sourceSequence, destinationSequence)
	self.SourceSequence      = sourceSequence
	self.DestinationSequence = destinationSequence
end

function self:GetSourceSequence ()
	return self.SourceSequence
end

function self:GetDestinationSequence ()
	return self.DestinationSequence
end
