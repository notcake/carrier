local self = {}
GarrysMod.HorizontalScrollbar = Class (self, Scrollbar)

function self:ctor ()
end

-- IView
-- Content layout
function self:GetPreferredSize (maximumWidth, maximumHeight)
	return maximumWidth or self:GetWidth (), self:GetThickness ()
end

-- View
function self:CreatePanel ()
	return vgui.Create ("DVScrollBar")
end

-- Scrollbar
function self:GetOrientation ()
	return Glass.Orientation.Horizontal
end
