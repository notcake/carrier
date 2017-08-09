local self = {}
ExternalView = Class (self, GarrysMod.View)

function self:ctor (panel)
	self.Handle = panel
	
	GarrysMod.Environment:RegisterView (panel, self)
end

-- IView
-- Layout
function self:GetRectangle ()
	local x, y = self:GetPosition ()
	local w, h = self:GetSize ()
	return x, y, w, h
end

function self:GetPosition ()
	return self.Environment:GetPosition (self, self.Handle)
end

function self:GetX ()
	local x, _ = self:GetPosition ()
	return x
end

function self:GetY ()
	local _, y = self:GetPosition ()
	return y
end

function self:GetSize ()
	return self.Environment:GetSize (self, self.Handle)
end

function self:GetWidth ()
	local w, _ = self:GetSize ()
	return w
end

function self:GetHeight ()
	local _, h = self:GetHeight ()
	return h
end
