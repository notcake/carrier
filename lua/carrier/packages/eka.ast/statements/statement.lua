local self = {}
AST.Statement = Class (self, AST.Node)

function self:ctor ()
end

-- Statement
function self:IsControlFlowStructure ()
	return false
end

function self:IsControlFlowDiscontinuity ()
	return false
end
