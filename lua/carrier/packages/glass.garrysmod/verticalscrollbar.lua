local self = {}
GarrysMod.VerticalScrollbar = Class (self, Scrollbar)

function self:ctor ()
end

-- IView
-- Content layout
function self:GetPreferredSize (maximumWidth, maximumHeight)
	return self:GetThickness (), maximumHeight or self:GetHeight ()
end

-- View
function self:CreatePanel ()
	return vgui.Create ("DVScrollBar")
end

-- Scrollbar
function self:GetOrientation ()
	return Glass.Orientation.Vertical
end
