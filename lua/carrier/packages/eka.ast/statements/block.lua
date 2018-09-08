local self = {}
AST.Statements.Block = Class (self, AST.Statement)

function self:ctor ()
	self.Statements = {}
end

-- Node
function self:GetChildEnumerator ()
	return ArrayEnumerator (self.Statements)
end

function self:ReplaceChildren (replacer)
	for i = 1, #self.Statements do
		self.Statements [i] = replacer (self.Statements [i]) or self.Statements [i]
	end
end

function self:ToString ()
	if #self.Statements == 0 then return "{}"
	elseif #self.Statements == 1 and self.Statements [1]:IsControlFlowDiscontinuity () then
		return "{ " .. self.Statements [1]:ToString () .. " }"
	else
		local lineEmitted      = false
		local lineBreakEmitted = false
		local previousWasControlFlowStructure = false
		
		local block = "{\n"
		for i = 1, #self.Statements do
			if previousWasControlFlowStructure and lineEmitted then
				block = block .. "\n"
				lineBreakEmitted = true
			end
			
			local statement = self.Statements [i]
			local line = string.gsub (statement:ToString (), "\n", "\n    ")
			
			if AST.Label:IsInstance (statement) then
				if lineEmitted and not lineBreakEmitted then
					block = block .. "\n"
					lineBreakEmitted = true
				end
				block = block .. line .. "\n"
			else
				if statement:IsControlFlowStructure () and lineEmitted and not lineBreakEmitted then
					block = block .. "\n"
					lineBreakEmitted = true
				end
				block = block .. "    " .. line .. "\n"
			end
			
			lineEmitted = true
			lineBreakEmitted = false
			previousWasControlFlowStructure = statement:IsControlFlowStructure ()
		end
		block = block .. "}"
		return block
	end
end

-- Statement
function self:IsControlFlowStructure ()
	return true
end

-- Block
function self:AddStatement (statement)
	self.Statements [#self.Statements + 1] = statement
end

function self:GetStatement (index)
	return self.Statements [index]
end

function self:GetStatementCount ()
	return #self.Statements
end

function self:GetStatementEnumerator ()
	return ArrayEnumerator (self.Statements)
end

function self:GetStatements ()
	local statements = {}
	for i = 1, #self.Statements do
		statements [#statements + 1] = self.Statements [i]
	end
	return statements
end

function self:InsertStatements (insertionIndex, statements)
	assert (insertionIndex <= #self.Statements + 1)
	
	for i = 1, #statements do
		table.insert (self.Statements, insertionIndex + i - 1, statements [i])
	end
end

function self:RemoveStatement (index)
	self:RemoveStatements (index, 1)
end

function self:RemoveStatements (index, length)
	for i = index, #self.Statements do
		self.Statements [i] = self.Statements [i + length]
	end
end
