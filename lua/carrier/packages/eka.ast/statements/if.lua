local self = {}
AST.Statements.If = Class (self, AST.Statement)

function self:ctor (condition, body, elseStatement)
	self.Condition = condition
	self.Body      = body
	self.Else      = elseStatement
end

-- Node
self.ChildrenFieldNames = { "Condition", "Body", "Else" }

function self:ToString ()
	local s = "if (" .. self.Condition:ToString () .. ") "
	local body = self.Body:ToString ()
	s = s .. body
	
	if self.Else then
		local elseBody = self.Else:ToString ()
		if string.find (body, "\n") then
			s = s .. " else " .. elseBody
		else
			s = s .. "\nelse " .. elseBody
		end
	end
	
	return s
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
