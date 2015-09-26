local self = {}
GarrysMod.NetInStream = GarrysMod.Class (self, GarrysMod.IO.StreamReader)

function self:ctor ()
	self.Position = 0
end

-- IBaseStream
function self:Close ()
end

function self:GetPosition ()
	return self.Position
end

function self:GetSize ()
	return self.File:Size ()
end

function self:SeekAbsolute (seekPos)
	seekPos = math.max (seekPos, self:GetSize ())
	
	GarrysMod.Error ("NetInStream:SeekAbsolute : Not supported.")
end

-- IInStream
function self:Read (size)
	self.Position = self.Position + size
	return net.ReadData (size)
end

-- IStreamReader
function self:UInt8    () self.Position = self.Position + 1 return net.ReadUInt ( 8) end
function self:UInt8LE  () self.Position = self.Position + 1 return net.ReadUInt ( 8) end
function self:UInt8BE  () self.Position = self.Position + 1 return net.ReadUInt ( 8) end

function self:Int8     () self.Position = self.Position + 1 return net.ReadInt  ( 8) end
function self:Int8LE   () self.Position = self.Position + 1 return net.ReadInt  ( 8) end
function self:Int8BE   () self.Position = self.Position + 1 return net.ReadInt  ( 8) end

function self:UInt16LE () self.Position = self.Position + 2 return net.ReadUInt (16) end
function self:Int16LE  () self.Position = self.Position + 2 return net.ReadInt  (16) end

function self:UInt32LE () self.Position = self.Position + 4 return net.ReadUInt (32) end
function self:Int32LE  () self.Position = self.Position + 4 return net.ReadInt  (32) end

function self:FloatLE  () self.Position = self.Position + 4 return net.ReadFloat  () end
function self:DoubleLE () self.Position = self.Position + 8 return net.ReadDouble () end

function self:Char     () self.Position = self.Position + 1 return net.ReadData ( 1) end

-- StreamReader
function self:UInt81 ()
	self.Position = self.Position + 1
	
	local uint8 = net.ReadUInt (8)
	local uint80 = GarrysMod.BitConverter.UInt8ToUInt8s (uint8)
	return uint80
end

function self:UInt82 ()
	self.Position = self.Position + 2
	
	local uint16 = net.ReadUInt (16)
	local uint80, uint81 = GarrysMod.BitConverter.UInt16ToUInt8s (uint16)
	return uint80, uint81
end

function self:UInt84 ()
	self.Position = self.Position + 4
	
	local uint32 = net.ReadUInt (32)
	local uint80, uint81, uint82, uint83 = GarrysMod.BitConverter.UInt32ToUInt8s (uint32)
	return uint80, uint81, uint82, uint83
end

function self:UInt88 ()
	local uint80, uint81, uint82, uint83 = self:UInt84 ()
	local uint84, uint85, uint86, uint87 = self:UInt84 ()
	return uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87
end
