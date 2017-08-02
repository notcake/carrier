local self = {}
GarrysMod.VerticalScrollbar = Class (self, Scrollbar)

function self:ctor ()
	self.UpButton = Scrollbar.Button (Glass.Direction.Up)
	self.UpButton:SetParent (self)
	self.DownButton = Scrollbar.Button (Glass.Direction.Down)
	self.DownButton:SetParent (self)
end

-- IView
-- Content layout
function self:GetPreferredSize (maximumWidth, maximumHeight)
	return self:GetThickness (), maximumHeight or self:GetHeight ()
end

-- Internal
function self:OnLayout (w, h)
	self.UpButton:SetRectangle (0, 0, w, w)
	self.DownButton:SetRectangle (0, h - w, w, w)
end

-- Scrollbar
function self:GetOrientation ()
	return Glass.Orientation.Vertical
end
