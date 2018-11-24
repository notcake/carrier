local self = {}
GarrysMod.UsermessageInputStream = Class(self, IO.StreamReader)

function self:ctor(buffer)
	self.Buffer   = buffer
	self.Position = 0
end

-- IBaseStream
function self:Close()
end

function self:GetPosition()
	return self.Position
end

function self:GetSize()
	return 256
end

function self:SeekAbsolute(seekPos)
	seekPos = math.min(seekPos, self:GetSize())
	
	Error("UsermessageInputStream:SeekAbsolute : Not supported.")
end

-- IInputStream
function self:Read(length)
	local t = {}
	for i = 1, length do
		t[#t + 1] = string.char(self:UInt8())
	end
	return table.concat(t)
end

-- IStreamReader
function self:UInt8   () self.Position = self.Position + 1 local n = self.Buffer:ReadChar() if n < 0 then n = n + 256 end return n end
function self:UInt8LE () self.Position = self.Position + 1 local n = self.Buffer:ReadChar() if n < 0 then n = n + 256 end return n end
function self:UInt8BE () self.Position = self.Position + 1 local n = self.Buffer:ReadChar() if n < 0 then n = n + 256 end return n end

function self:Int8    () self.Position = self.Position + 1 return self.Buffer:ReadChar() end
function self:Int8LE  () self.Position = self.Position + 1 return self.Buffer:ReadChar() end
function self:Int8BE  () self.Position = self.Position + 1 return self.Buffer:ReadChar() end

function self:UInt16LE() self.Position = self.Position + 2 local n = self.Buffer:ReadShort() if n < 0 then n = n + 65536 end return n end
function self:Int16LE () self.Position = self.Position + 2 return self.Buffer:ReadShort() end

function self:UInt32LE() self.Position = self.Position + 4 local n = self.Buffer:ReadLong() if n < 0 then n = n + 4294967296 end return end
function self:Int32LE () self.Position = self.Position + 4 return self.Buffer:ReadLong() end

function self:FloatLE () self.Position = self.Position + 4 return self.Buffer:ReadFloat() end

-- StreamReader
function self:UInt81()
	self.Position = self.Position + 1
	
	local int8 = self.Buffer:ReadChar()
	local uint80 = BitConverter.Int8ToUInt8s(int8)
	return uint80
end

function self:UInt82()
	self.Position = self.Position + 2
	
	local int16 = self.Buffer:ReadShort()
	local uint80, uint81 = BitConverter.Int16ToUInt8s(int16)
	return uint80, uint81
end

function self:UInt84()
	self.Position = self.Position + 4
	
	local int32 = self.Buffer:ReadLong()
	local uint80, uint81, uint82, uint83 = BitConverter.Int32ToUInt8s(int32)
	return uint80, uint81, uint82, uint83
end

function self:UInt88()
	local uint80, uint81, uint82, uint83 = self:UInt84()
	local uint84, uint85, uint86, uint87 = self:UInt84()
	return uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87
end
