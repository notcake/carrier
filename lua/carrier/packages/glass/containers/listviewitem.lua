local self = {}
Glass.ListViewItem = Class (self, Glass.View)

function self:ctor ()
	self.Hovered = false
end

-- IView
-- Internal
function self:OnMouseEnter ()
	self.Hovered = true
end

function self:OnMouseLeave ()
	self.Hovered = false
end

function self:Render (w, h, render2d)
	if self.Hovered then
		render2d:FillRectangle (Color.WithAlpha (Color.LightBlue, 192), 0, 0, w, h)
	end
end
