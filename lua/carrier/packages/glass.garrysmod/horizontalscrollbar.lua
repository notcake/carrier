local self = {}
GarrysMod.HorizontalScrollbar = Class (self, Scrollbar)

function self:ctor ()
	self.LeftButton = Scrollbar.Button (Glass.Direction.Left)
	self.LeftButton:SetParent (self)
	self.RightButton = Scrollbar.Button (Glass.Direction.Right)
	self.RightButton:SetParent (self)
end

-- IView
-- Content layout
function self:GetPreferredSize (maximumWidth, maximumHeight)
	return maximumWidth or self:GetWidth (), self:GetThickness ()
end

-- Internal
function self:OnLayout (w, h)
	self.LeftButton:SetRectangle (0, 0, h, h)
	self.RightButton:SetRectangle (w - h, 0, h, h)
end

-- Scrollbar
function self:GetOrientation ()
	return Glass.Orientation.Horizontal
end
