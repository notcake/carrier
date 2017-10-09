local self = {}
GarrysMod.RemoteChatTextSink = Class (self, GarrysMod.LineBufferedTextSink)

function self:ctor (ply)
	self.Player = ply
end

-- LineBufferedTextSink
function self:AppendBuffer (text, color)
	self.Buffer [#self.Buffer + 1] = text
end

function self:CommitBuffer ()
	if not self.Player or not self.Player:IsValid () then return end
	
	self.Player:ChatPrint (table.concat (self.Buffer))
end
