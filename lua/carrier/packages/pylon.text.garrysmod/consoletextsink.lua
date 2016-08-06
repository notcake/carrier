local self = {}
GarrysMod.ConsoleTextSink = Class (self, Text.IColoredTextSink)

function self:ctor ()
end

-- IColoredTextSink
local whiteColor = Color (255, 255, 255, 255)
function self:Write (text, color)
	color = color or whiteColor
	MsgC (color, text)
end
