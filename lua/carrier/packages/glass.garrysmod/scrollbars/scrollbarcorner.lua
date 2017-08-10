local self = {}
GarrysMod.ScrollbarCorner = Class (self, Glass.View)

function self:ctor ()
end

-- IView
-- Content layout
function self:GetPreferredSize (maximumWidth, maximumHeight)
	return GarrysMod.Skin.Default.Metrics.ScrollbarThickness, GarrysMod.Skin.Default.Metrics.ScrollbarThickness
end

-- Internal
function self:Render (w, h, render2d)
	render2d:FillRectangle (Color.FromRGBA8888 (240, 240, 240, 255), 0, 0, w, h)
end
