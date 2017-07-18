local self = {}
Core.ITextRenderer = Interface (self)

function self:ctor ()
end

function self:GetTextSize (text, font)
	Error ("ITextRenderer:GetTextSize : Not implemented.")
end

function self:DrawText (text, font, x, y)
	Error ("ITextRenderer:DrawText : Not implemented.")
end

function self:DrawTextAligned (text, font, x, y, horizontalAlignment, verticalAlignment)
	Error ("ITextRenderer:DrawText : Not implemented.")
end
