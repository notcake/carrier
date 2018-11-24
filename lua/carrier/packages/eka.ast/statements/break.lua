local self = {}
AST.Statements.Break = Class(self, AST.Statement)

function self:ctor()
end

-- Node
function self:ToString()
	return "break;"
end

-- Statement
function self:IsControlFlowDiscontinuity()
	return true
end
