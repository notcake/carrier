local self = {}
Text.NullTextSink = Class(self, Text.IColoredTextSink)

function self:ctor()
end

-- IColoredTextSink
function self:Write(text, color)
end

function self:WriteLine(text, color)
end
