local self = {}
GarrysMod.ChatTextSink = Class (self, GarrysMod.LineBufferedTextSink)

function self:ctor ()
end

-- LineBufferedTextSink
function self:AppendBuffer (text, color)
	self.Buffer [#self.Buffer + 1] = color
	self.Buffer [#self.Buffer + 1] = text
end

function self:CommitBuffer ()
	chat.AddText (unpack (self.Buffer))
end
