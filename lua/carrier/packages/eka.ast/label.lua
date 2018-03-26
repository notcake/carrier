local self = {}
AST.Label = Class (self, AST.Node)

function self:ctor (name)
	self.Name = name
end

-- Label
function self:GetName ()
	return self.Name
end

function self:SetName (name)
	self.Name = name
end
