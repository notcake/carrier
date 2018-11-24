local self = {}
AST.Statements.Continue = Class(self, AST.Statement)

function self:ctor()
end

-- Node
function self:ToString()
	return "continue;"
end

-- Statement
function self:IsControlFlowDiscontinuity()
	return true
end
