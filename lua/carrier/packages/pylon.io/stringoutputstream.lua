local self = {}
IO.StringOutputStream = Class(self, IO.StreamWriter)

local string_char = string.char
local string_sub  = string.sub

function self:ctor()
	self.FlattenedData = ""
	self.Data          = {}
	self.DataPosition  = 0
	self.Position      = 0
end

-- IBaseStream
function self:Close()
	self:Clear()
end

function self:GetPosition()
	return self.Position
end

function self:GetSize()
	return math.max(#self.FlattenedData, self.Position)
end

function self:SeekAbsolute(seekPos)
	if self.Position == seekPos then return end
	
	self:Flatten()
	
	self.DataPosition = seekPos
	self.Position     = seekPos
end

-- IOutputStream
function self:Write(data, length)
	length = length or #data
	
	if length < #data then
		data = string_sub(data, 1, length)
	end
	
	self.Data[#self.Data + 1] = data
	self.Position = self.Position + length
end

-- StreamWriter
function self:UInt81(uint80)
	self.Data[#self.Data + 1] = string_char(uint80)
	self.Position = self.Position + 1
end

function self:UInt82(uint80, uint81)
	self.Data[#self.Data + 1] = string_char(uint80, uint81)
	self.Position = self.Position + 2
end

function self:UInt84(uint80, uint81, uint82, uint83)
	self.Data[#self.Data + 1] = string_char(uint80, uint81, uint82, uint83)
	self.Position = self.Position + 4
end

function self:UInt88(uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87)
	self.Data[#self.Data + 1] = string_char(uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87)
	self.Position = self.Position + 8
end

-- StringOutputStream
function self:Clear()
	self.FlattenedData = ""
	self.Data          = {}
	self.DataPosition  = 0
	self.Position      = 0
end

function self:ToString()
	self:Flatten()
	
	return self.FlattenedData
end

-- Internal
function self:Flatten()
	if #self.Data == 0 then return end
	
	local data = table.concat(self.Data)
	self.FlattenedData = string.sub(self.FlattenedData, 1, self.DataPosition) .. data .. string.sub(self.FlattenedData, self.Position + 1)
	
	self.Data = {}
	self.DataPosition = self.Position
end
