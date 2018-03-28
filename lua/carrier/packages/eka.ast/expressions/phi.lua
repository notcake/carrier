local self = {}
AST.Expressions.Phi = Class (self)

function AST.Expressions.Phi.Union (expression1, value1, expression2, value2)
	local phi = AST.Expressions.Phi ()
	phi:Add (node1, value1)
	phi:Add (node2, value2)
	return phi
end

function AST.Expressions.Phi.Optional (expression, value)
	local phi = AST.Expressions.Phi ()
	phi:Add (nil, nil)
	phi:Add (expression, value)
	return phi
end

function self:ctor ()
	self.Optional = false
	self.Expressions = {}
end

-- Node
function self:GetChildEnumerator ()
	return KeyEnumerator (self.Expressions)
end

function self:ToString ()
	local values = {}
	if self:IsOptional () then
		values [#values + 1] = "nil"
	end
	for node, _ in self:GetChildEnumerator () do
		values [#values + 1] = node:ToString ()
	end
	return "Φ(" .. table.concat (values) .. ")"
end

-- Expression
function self:IsPhi ()
	return true
end

-- Phi
function self:IsOptional ()
	return self.Optional
end

-- Internal
function self:Add (expression, value)
	if expression then
		if expression:IsPhi () then
			self.Optional = self.Optional or expression:IsOptional ()
			for expression, value in expression:GetChildEnumerator () do
				self.Expressions [expression] = value
			end
		else
			self.Expressions [expression] = value
		end
	else
		self.Optional = true
	end
end
