local self = {}
AST.Node = Class (self)

function self:ctor ()
end

-- Node
function self:IsPhi ()
	return false
end

function self:Clone (cachingCloner)
	local clone = self:GetType () ()
	for k, v in pairs (self) do
		clone [k] = AST.Node:IsInstance (v) and cachingCloner (v) or v
	end
	
	return clone
end

self.ChildrenFieldNames = {}
function self:GetChildEnumerator ()
	local i = 0
	return function ()
		i = i + 1
		return self [self.ChildrenFieldNames [i]]
	end
end

function self:ReplaceChildren (replacer)
	for i = 1, #self.ChildrenFieldNames do
		local fieldName = self.ChildrenFieldNames [i]
		local childNode = self [fieldName]
		if childNode then
			self [fieldName] = replacer (childNode) or childNode
		end
	end
end

-- Visitors
function self:VisitChildren (visitor)
	for childNode in self:GetChildEnumerator () do
		visitor (childNode)
	end
end

function self:PreVisit (visitor)
	visitor (self)
	
	self:VisitChildren (
		function (childNode)
			return childNode:PreVisit (visitor)
		end
	)
end

function self:PostVisit (visitor)
	self:VisitChildren (
		function (childNode)
			return childNode:PostVisit (visitor)
		end
	)
	
	visitor (self)
end

function self:Visit (preVisitor, postVisitor)
	preVisitor (self)
	
	self:VisitChildren (
		function (childNode)
			return childNode:Visit (preVisitor, postVisitor)
		end
	)
	
	postVisitor (self)
end

function self:PreReplaceVisit (replacer)
	self:ReplaceChildren (
		function (childNode)
			local replacement = replacer (childNode)
			local childNode = replacement or childNode
			childNode:PreReplaceVisit (replacer)
			return replacement
		end
	)
end
self.ReplaceVisit = self.PreReplaceVisit

function self:PostReplaceVisit (replacer)
	self:ReplaceChildren (
		function (childNode)
			childNode:PostReplaceVisit (replacer)
			return replacer (childNode)
		end
	)
end

function self:ReplaceVisit (preReplacer, postReplacer)
	self:ReplaceChildren (
		function (childNode)
			local replacement = preReplacer (childNode)
			local childNode = replacement or childNode
			childNode:ReplaceVisit (preReplacer, postReplacer)
			return postReplacer (childNode) or replacement
		end
	)
end
