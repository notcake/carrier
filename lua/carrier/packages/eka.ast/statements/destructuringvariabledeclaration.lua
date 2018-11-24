local self = {}
AST.Statements.DestructuringVariableDeclaration = Class(self, AST.Statement)

function self:ctor(expression)
	self.Identifiers = {}
	self.Expression  = expression
end

-- Node
function self:GetChildEnumerator()
	for i = 1, #self.Identifiers do
		coroutine.yield(self.Identifiers[i])
	end
	
	coroutine.yield(self.Expression)
end
self.GetChildEnumerator = YieldEnumeratorFactory(self.GetChildEnumerator)

function self:ReplaceChildren(replacer)
	for i = 1, #self.Identifiers do
		self.Identifiers[i] = replacer(self.Identifiers[i]) or self.Identifiers[i]
	end
	
	self.Expression = replacer(self.Expression) or self.Expression
end

function self:ToString()
	if #self.Identifiers == 0 then
		return "var() = " .. self.Expression:ToString()
	else
		local destructuringVariableDeclaration = "var " .. self.Identifiers[1]:ToString()
		for i = 2, #self.Identifiers do
			destructuringVariableDeclaration = destructuringVariableDeclaration .. ", " .. self.Identifiers[i]:ToString()
		end
		destructuringVariableDeclaration = destructuringVariableDeclaration .. " = " .. self.Expression:ToString() .. ";"
		return destructuringVariableDeclaration
	end
end

-- DestructuringVariableDeclaration
function self:AddIdentifier(identifier)
	self.Identifiers[#self.Identifiers + 1] = identifier
end

function self:GetIdentifier(index)
	return self.Identifier[index]
end

function self:GetIdentifierCount()
	return #self.Identifiers
end

function self:GetIdentifierEnumerator()
	return ArrayEnumerator(self.Identifiers)
end

function self:GetExpression()
	return self.Expression
end

function self:SetExpression(expression)
	self.Expression = expression
end
