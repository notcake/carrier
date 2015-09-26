local self = {}
GarrysMod.FileInStream = GarrysMod.Class (self, GarrysMod.IO.StreamReader)

function self:ctor (file)
	self.File = file
end

-- IBaseStream
function self:Close ()
	if not self.File then return end
	
	self.File:Close ()
	self.File = nil
end

function self:GetPosition ()
	return self.File:Tell ()
end

function self:GetSize ()
	return self.File:Size ()
end

function self:SeekAbsolute (seekPos)
	seekPos = math.max (seekPos, self:GetSize ())
	self.File:Seek (seekPos)
end

-- IInStream
function self:Read (size)
	return self.File:Read (size)
end

-- IStreamReader
function self:UInt8   () return self.File:ReadByte () end
function self:UInt8LE () return self.File:ReadByte () end
function self:UInt8BE () return self.File:ReadByte () end

function self:Int8   () local n = self.File:ReadByte () if n >= 128 then n = n - 256 end return n end
function self:Int8LE () local n = self.File:ReadByte () if n >= 128 then n = n - 256 end return n end
function self:Int8BE () local n = self.File:ReadByte () if n >= 128 then n = n - 256 end return n end

function self:UInt16LE () local n = self.File:ReadShort () if n < 0 then n = n + 65536 end return n end

function self:Int16LE () return self.File:ReadShort () end

function self:UInt32LE () local n = self.File:ReadLong () if n < 0 then n = n + 4294967296 end return n end

function self:Int32LE () return self.File:ReadLong () end

function self:FloatLE  () return self.File:ReadFloat  () end
function self:DoubleLE () return self.File:ReadDouble () end

-- StreamReader
function self:UInt81 ()
	local uint8 = self.File:ReadByte ()
	local uint80 = GarrysMod.BitConverter.UInt8ToUInt8s (uint8)
	return uint80
end

function self:UInt82 ()
	local int16 = self.File:ReadShort ()
	local uint80, uint81 = GarrysMod.BitConverter.Int16ToUInt8s (int16)
	return uint80, uint81
end

function self:UInt84 ()
	local int32 = self.File:ReadLong ()
	local uint80, uint81, uint82, uint83 = GarrysMod.BitConverter.Int32ToUInt8s (int32)
	return uint80, uint81, uint82, uint83
end

function self:UInt88 ()
	local uint80, uint81, uint82, uint83 = self:UInt84 ()
	local uint84, uint85, uint86, uint87 = self:UInt84 ()
	return uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87
end
