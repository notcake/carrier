local self = {}
Xml.Node = Class (self)

function self:ctor ()
	self.Parent = nil
end

function self:GetParent ()
	return self.Parent
end

function self:SetParent (element)
	if self.Parent == element then return end
	
	local previousParent = self.Parent
	self.Parent = element
	
	if previousParent then
		previousParent:RemoveChild (self)
	end
	if self.Parent then
		self.Parent:AddChild (self)
	end
end
