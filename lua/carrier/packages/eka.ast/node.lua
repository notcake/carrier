local self = {}
AST.Node = Class (self)

function self:ctor ()
end

-- Node
function self:Clone (cachingCloner)
	local clone = self:GetType () ()
	for k, v in pairs (self) do
		clone [k] = AST.Node:IsInstance (v) and cachingCloner (v) or v
	end
	
	return clone
end

function self:GetChildEnumerator ()
	return NullEnumerator ()
end

function self:PreVisit (visitor)
	visitor (self)
	
	for childNode in self:GetChildEnumerator () do
		childNode:Visit (visitor)
	end
end
self.Visit = self.PreVisit