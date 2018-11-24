local self = {}
Scrollbar.Button = Class(self, Glass.View, Glass.IButton)

local font = Glass.Font("Webdings", 20)

function self:ctor(direction)
	self.Direction = direction
	
	self.ButtonBehaviour = Glass.ButtonBehaviour(self)
	
	self:SetConsumesMouseEvents(true)
end

-- IView
-- Internal
function self:Render(w, h, render2d)
	render2d:FillRectangle(Color.FromRGBA8888(224, 224, 224, 255), 0, 0, w, h)
	
	if self.ButtonBehaviour:IsPressed() then
		render2d:FillRectangle(Color.LightBlue, 0, 0, w, h)
	elseif self.ButtonBehaviour:IsHovered() then
		render2d:FillRectangle(Color.WithAlpha(Color.LightBlue, 192), 0, 0, w, h)
	end
	
	local glyph = Scrollbar.Button.Glyphs.Up
	if     self.Direction == Glass.Direction.Up    then glyph = Scrollbar.Button.Glyphs.Up
	elseif self.Direction == Glass.Direction.Down  then glyph = Scrollbar.Button.Glyphs.Down
	elseif self.Direction == Glass.Direction.Left  then glyph = Scrollbar.Button.Glyphs.Left
	elseif self.Direction == Glass.Direction.Right then glyph = Scrollbar.Button.Glyphs.Right end
	render2d:DrawGlyph(Color.WithAlpha(Color.Black, 0xE8), glyph, 0.5 * (self:GetWidth() - glyph:GetWidth()), 0.5 * (self:GetHeight() - glyph:GetHeight()))
end

-- Button
function self:GetDirection()
	return self.Direction
end

function self:IsHovered()
	return self.ButtonBehaviour:IsHovered()
end

function self:IsPressed()
	return self.ButtonBehaviour:IsPressed()
end
