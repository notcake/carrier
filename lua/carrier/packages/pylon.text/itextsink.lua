local self = {}
Text.ITextSink = Interface(self)

function self:ctor()
end

function self:Write(text)
	Error("ITextSink:Write : Not implemented.")
end

function self:WriteLine(text)
	self:Write(text)
	self:Write("\n")
end
