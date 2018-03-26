local self = {}
AST.Continue = Class (self, AST.Statement)

function self:ctor ()
end

-- Statement
function self:IsControlFlowDiscontinuity ()
	return true
end
