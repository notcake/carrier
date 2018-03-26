local self = {}
AST.Block = Class (self, AST.Statement)

function self:ctor ()
	self.Statements = {}
end

-- Statement
function self:IsControlFlowStructure ()
	return true
end

-- Block
function self:AddStatement (statement)
	self.Statements [#self.Statements + 1] = statement
end

function self:GetStatementEnumerator ()
	return ArrayEnumerator (self.Statements)
end
