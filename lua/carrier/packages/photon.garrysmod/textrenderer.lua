local utf8 = require ("utf8")

local self = {}
TextRenderer = Class (self, ITextRenderer)

function self:ctor ()
end

function self:GetTextSize (text, font)
	local text = self:Delocalize (text)
	
	surface.SetFont (font:GetId ())
	return surface.GetTextSize (text)
end

function self:DrawText (text, font, color, x, y)
	local text = self:Delocalize (text)
	
	surface.SetFont (font:GetId ())
	surface.SetTextColor (Color.ToRGBA8888 (color))
	surface.SetTextPos (x, y)
	surface.DrawText (text)
end

function self:DrawTextAligned (text, font, color, x, y, horizontalAlignment, verticalAlignment)
	if horizontalAlignment == Glass.HorizontalAlignment.Left and
	   verticalAlignment == Glass.VerticalAlignment.Top then
		self:DrawText (text, font, color, x, y)
		return
	end
	
	local text = self:Delocalize (text)
	
	surface.SetFont (font:GetId ())
	surface.SetTextColor (Color.ToRGBA8888 (color))
	
	local w, h = surface.GetTextSize (text)
	if horizontalAlignment == Glass.HorizontalAlignment.Center then
		x = x - 0.5 * w
	elseif horizontalAlignment == Glass.HorizontalAlignment.Right then
		x = x - w
	end
	if verticalAlignment == Glass.VerticalAlignment.Center then
		y = y - 0.5 * h
	elseif verticalAlignment == Glass.VerticalAlignment.Bottom then
		y = y - h
	end
	
	surface.SetTextPos (x, y)
	surface.DrawText (text)
end

-- Internal
-- Hack to avoid localization
local hash = string.byte ("#")
local zeroWidthSpace = utf8.char (0x200B)
function self:Delocalize (text)
	if string.byte (text) == hash and
	   language.GetPhrase (text) ~= text then
		text = zeroWidthSpace .. text
	end
	
	return text
end
