local self = {}
Analysis.ControlFlowGraph.Link = Class (self)

function self:ctor (sourceSequence, destinationSequence)
	self.SourceSequence      = sourceSequence
	self.DestinationSequence = destinationSequence
	
	self.ConditionResult = nil
end

function self:GetSourceSequence ()
	return self.SourceSequence
end

function self:GetDestinationSequence ()
	return self.DestinationSequence
end

function self:GetConditionResult ()
	return self.ConditionResult
end

function self:SetConditionResult (conditionResult)
	self.ConditionResult = conditionResult
end
