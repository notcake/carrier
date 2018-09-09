local self = {}
AST.Statements.DestructuringAssignment = Class (self, AST.Statement)

function self:ctor (expression)
	self.AccessExpressions = {}
	self.Expression        = expression
end

-- Node
function self:GetChildEnumerator ()
	for i = 1, #self.AccessExpressions do
		coroutine.yield (self.AccessExpressions [i])
	end
	
	coroutine.yield (self.Expression)
end
self.GetChildEnumerator = YieldEnumeratorFactory (self.GetChildEnumerator)

function self:ReplaceChildren (replacer)
	for i = 1, #self.AccessExpressions do
		self.AccessExpressions [i] = replacer (self.AccessExpressions [i]) or self.AccessExpressions [i]
	end
	
	self.Expression = replacer (self.Expression) or self.Expression
end

function self:ToString ()
	if #self.AccessExpressions == 0 then
		return "() = " .. self.Expression:ToString ()
	else
		local destructuringAssignment = self.AccessExpressions [1]:ToString ()
		for i = 2, #self.AccessExpressions do
			destructuringAssignment = destructuringAssignment .. ", " .. self.AccessExpressions [i]:ToString ()
		end
		destructuringAssignment = destructuringAssignment .. " = " .. self.Expression:ToString () .. ";"
		return destructuringAssignment
	end
end

-- DestructuringAssignment
function self:AddAccessExpression (accessExpression)
	self.AccessExpressions [#self.AccessExpressions + 1] = accessExpression
end

function self:GetAccessExpression (index)
	return self.AccessExpressions [index]
end

function self:GetAccessExpressionCount ()
	return #self.AccessExpressions
end

function self:GetAccessExpressionEnumerator ()
	return ArrayEnumerator (self.AccessExpressions)
end

function self:GetExpression ()
	return self.Expression
end

function self:SetExpression (expression)
	self.Expression = expression
end
