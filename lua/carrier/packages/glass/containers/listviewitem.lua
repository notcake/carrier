local self = {}
Glass.ListViewItem = Class(self, Glass.View)

function self:ctor()
end

-- IView
-- Internal
function self:Render(w, h, render2d)
	if self:IsMouseOver() then
		render2d:FillRectangle(Color.WithAlpha(Color.LightBlue, 192), 0, 0, w, h)
	end
end
