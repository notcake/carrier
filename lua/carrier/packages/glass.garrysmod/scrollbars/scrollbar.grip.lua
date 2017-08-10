local self = {}
Scrollbar.Grip = Class (self, Glass.View)

function self:ctor (orientation)
	self.Orientation = orientation
	
	self.ButtonBehaviour = Glass.ButtonBehaviour (self)
	
	self:SetConsumesMouseEvents (true)
end

-- IView
-- Internal
function self:Render (w, h, render2d)
	render2d:FillRectangle (Color.FromRGBA8888 (224, 224, 224, 255), 0, 0, w, h)
	
	if self.ButtonBehaviour:IsPressed () then
		render2d:FillRectangle (Color.LightBlue, 0, 0, w, h)
	elseif self.ButtonBehaviour:IsHovered () then
		render2d:FillRectangle (Color.WithAlpha (Color.LightBlue, 192), 0, 0, w, h)
	end
end

-- Grip
function self:GetOrientation ()
	return self.Orientation
end
