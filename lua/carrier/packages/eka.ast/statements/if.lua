local self = {}
AST.If = Class (self, AST.Statement)

function self:ctor (condition, body, elseStatement)
	self.Condition = condition
	self.Body      = body
	self.Else      = elseStatement
end

-- Statement
function self:IsControlFlowStructure ()
	return true
end

-- If
function self:GetCondition ()
	return self.Condition
end

function self:GetBody ()
	return self.Body
end

function self:GetElse ()
	return self.Else
end

function self:SetCondition (condition)
	self.Condition = condition
end

function self:SetBody (body)
	self.Body = body
end

function self:SetElse (elseStatement)
	self.Else = elseStatement
end
