local self = {}
AST.Goto = Class (self, AST.Statement)

function self:ctor (label)
	self.Label = label
end

-- Statement
function self:IsControlFlowDiscontinuity ()
	return true
end

-- Goto
function self:GetLabel ()
	return self.Label
end

function self:SetLabel (label)
	self.Label = label
end
