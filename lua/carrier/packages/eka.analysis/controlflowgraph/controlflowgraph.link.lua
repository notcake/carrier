local self = {}
Analysis.ControlFlowGraph.Link = Class (self)

function self:ctor (sourceSequence, destinationSequence)
	self.SourceSequence      = sourceSequence
	self.DestinationSequence = destinationSequence
	
	self.Fallthrough = false
	self.Jump        = false
end

-- Identity
function self:GetSourceSequence ()
	return self.SourceSequence
end

function self:GetDestinationSequence ()
	return self.DestinationSequence
end

function self:IncludesFallthrough ()
	return self.Fallthrough
end

function self:IncludesJump ()
	return self.Jump
end

self.IncludesConditionFail = self.IncludesFallthrough
self.IncludesConditionPass = self.IncludesJump

function self:SetIncludesFallthrough (includesFallthrough)
	self.Fallthrough = includesFallthrough == nil and true or includesFallthrough
end

function self:SetIncludesJump (includesJump)
	self.Jump = includesJump == nil and true or includesJump
end

self.SetIncludesConditionFail = self.SetIncludesFallthrough
self.SetIncludesConditionPass = self.SetIncludesJump
