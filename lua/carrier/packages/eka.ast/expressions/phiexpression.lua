local self = {}
AST.PhiExpression = Class (self)

function AST.PhiExpression.Union (expression1, value1, expression2, value2)
	local phi = AST.PhiExpression ()
	phi:Add (node1, value1)
	phi:Add (node2, value2)
	return phi
end

function AST.PhiExpression.Optional (expression, value)
	local phi = AST.PhiExpression ()
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
function self:IsPhiExpression ()
	return true
end

-- PhiExpression
function self:IsOptional ()
	return self.Optional
end

-- Internal
function self:Add (expression, value)
	if expression then
		if expression:IsPhiExpression () then
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
