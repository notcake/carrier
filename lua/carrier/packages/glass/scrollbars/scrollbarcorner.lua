local self = {}
Glass.ScrollbarCorner = Class(self, Glass.View)

function self:ctor()
end

-- IView
-- Content layout
function self:GetPreferredSize(maximumWidth, maximumHeight)
	local thickness = self:GetThickness()
	return thickness, thickness
end

-- ScrollbarCorner
-- Metrics
function self:GetThickness()
	return self:GetSkin():GetScrollbarThickness()
end

-- Internal
function self:Render(w, h, render2d)
	render2d:FillRectangle(Color.FromRGBA8888(240, 240, 240, 255), 0, 0, w, h)
end
