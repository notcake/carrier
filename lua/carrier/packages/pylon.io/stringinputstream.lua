local self = {}
IO.StringInputStream = Class(self, IO.StreamReader)

local string_byte = string.byte
local string_find = string.find
local string_sub  = string.sub

function self:ctor(data)
	self.Data     = data
	self.Size     = #data
	
	self.Position = 0
end

-- IBaseStream
function self:Close()
	self.Data = ""
end

function self:GetPosition()
	return self.Position
end

function self:GetSize()
	return self.Size
end

function self:SeekAbsolute(seekPos)
	seekPos = math.min(seekPos, self:GetSize())
	self.Position = seekPos
end

-- IInputStream
function self:Read(length)
	local data = string_sub(self.Data, self.Position + 1, self.Position + length)
	self.Position = self.Position + length
	return data
end

-- IStreamReader
function self:StringZ()
	local terminatorPosition = string_find(self.Data, "\0", self.Position + 1, true)
	if terminatorPosition then
		local str = string_sub(self.Data, self.Position + 1, terminatorPosition - 1)
		self.Position = terminatorPosition
		return str
	else
		local str = string_sub(self.Data, self.Position + 1)
		self.Position = #self.Data
		return str
	end
end

-- StreamReader
function self:UInt81()
	local uint80 = string_byte(self.Data, self.Position + 1, self.Position + 1)
	self.Position = self.Position + 1
	return uint80
end

function self:UInt82()
	local uint80, uint81 = string_byte(self.Data, self.Position + 1, self.Position + 2)
	self.Position = self.Position + 2
	return uint80, uint81
end

function self:UInt84()
	local uint80, uint81, uint82, uint83 = string_byte(self.Data, self.Position + 1, self.Position + 4)
	self.Position = self.Position + 4
	return uint80, uint81, uint82, uint83
end

function self:UInt88()
	local uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87 = string_byte(self.Data, self.Position + 1, self.Position + 8)
	self.Position = self.Position + 8
	return uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87
end
