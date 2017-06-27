local self = {}
Text.IColoredTextSink = Interface (self, Text.ITextSink)

function self:ctor ()
end

function self:Write (text, color)
	Error ("IColoredTextSink:Write : Not implemented.")
end

function self:WriteLine (text, color)
	self:Write (text, color)
	self:Write ("\n", color)
end
