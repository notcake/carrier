local self = {}
GarrysMod.LineBufferedTextSink = Class (self, Text.IColoredTextSink)

local Util_IndexOfLastLineBreak = GarrysMod.Util.IndexOfLastLineBreak

function self:ctor ()
	self.Buffer = {}
end

-- IColoredTextSink
local whiteColor = Color (255, 255, 255, 255)
function self:Write (text, color)
	if not text then return end
	
	color = color or whiteColor
	
	local lineBreakIndex = Util_IndexOfLastLineBreak (text)
	if not lineBreakIndex then
		self:AppendBuffer (text, color)
	else
		-- Buffer text up to line break and commit
		self:AppendBuffer (string.sub (text, 1, lineBreakIndex - 1), color)
		self:CommitBuffer ()
		self:ClearBuffer ()
		
		-- Buffer remainder after line break
		if lineBreakIndex < #text then
			self:AppendBuffer (string.sub (text, lineBreakIndex + 1), color)
		end
	end
end

function self:WriteLine (text, color)
	if not text then return end
	
	color = color or whiteColor
	
	self:AppendBuffer (text, color)
	self:CommitBuffer ()
	self:ClearBuffer ()
end

-- LineBufferedTextSink
function self:AppendBuffer (text, color)
	Error ("LineBufferedTextSink:AppendBuffer : Not implemented.")
end

function self:ClearBuffer ()
	for i = #self.Buffer, 1, -1 do
		self.Buffer = nil
	end
end

function self:CommitBuffer ()
	Error ("LineBufferedTextSink:CommitBuffer : Not implemented.")
end
