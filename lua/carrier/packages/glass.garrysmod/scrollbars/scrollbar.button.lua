local self = {}
Scrollbar.Button = Class (self, GarrysMod.View)

local font = GarrysMod.Font.Create ("Webdings", 20)

function self:ctor (direction)
	self.Direction = direction
	
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
	
	local glyph = ""
	if     self.Direction == Glass.Direction.Up    then glyph = "▲"
	elseif self.Direction == Glass.Direction.Down  then glyph = "▼"
	elseif self.Direction == Glass.Direction.Left  then glyph = "◀"
	elseif self.Direction == Glass.Direction.Right then glyph = "▶" end
	GarrysMod.TextRenderer:DrawTextAligned (glyph, font, GarrysMod.Skin.Default.Colors.Text, 0.5 * w, 0.5 * h, Glass.HorizontalAlignment.Center, Glass.VerticalAlignment.Center)
end

-- Button
function self:GetDirection ()
	return self.Direction
end
