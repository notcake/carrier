local self = {}
Analysis.ControlFlowGraph.Link = Class (self, Analysis.ControlFlowGraph.ILink)

function self:ctor (sourceBlock, destinationBlock)
	self.Fallthrough = false
	self.Jump        = false
end

-- Link
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
