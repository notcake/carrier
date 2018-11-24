local self = {}
ExternalView = Class(self, Glass.View)

function self:ctor(environment, panel)
	self:InjectHandle(environment, panel)
end

-- IView
-- Hierarchy
function self:GetParent()
	return self.Environment:GetParent(self, self.Handle)
end

-- Layout
function self:GetRectangle()
	local x, y = self:GetPosition()
	local w, h = self:GetSize()
	return x, y, w, h
end

function self:GetPosition()
	return self.Environment:GetPosition(self, self.Handle)
end

function self:GetX()
	local x, _ = self:GetPosition()
	return x
end

function self:GetY()
	local _, y = self:GetPosition()
	return y
end

function self:GetSize()
	return self.Environment:GetSize(self, self.Handle)
end

function self:GetWidth()
	local w, _ = self:GetSize()
	return w
end

function self:GetHeight()
	local _, h = self:GetHeight()
	return h
end
