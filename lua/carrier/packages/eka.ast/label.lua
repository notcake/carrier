local self = {}
AST.Label = Class (self, AST.Node)

function self:ctor (identifier)
	self.Identifier = identifier
end

-- Node
function self:GetChildEnumerator ()
	return SingleValueEnumerator (self.Identifier)
end

-- Label
function self:GetIdentifier ()
	return self.Identifier
end

function self:SetIdentifier (identifier)
	self.Identifier = identifier
end
