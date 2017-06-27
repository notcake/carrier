local self = {}
GarrysMod.FileInputStream = Class (self, IO.StreamReader)

function GarrysMod.FileInputStream.FromPath (path, pathId)
	local f = file.Open (path, "rb", pathId)
	if not f then return nil end
	
	return GarrysMod.FileInputStream:CreateInstance (f)
end

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

-- IInputStream
function self:Read (length)
	return self.File:Read (length) or ""
end

-- IStreamReader
function self:UInt8   () return self.File:ReadByte () or 0 end
function self:UInt8LE () return self.File:ReadByte () or 0 end
function self:UInt8BE () return self.File:ReadByte () or 0 end

function self:Int8   () local n = self.File:ReadByte () or 0 if n >= 128 then n = n - 256 end return n end
function self:Int8LE () local n = self.File:ReadByte () or 0 if n >= 128 then n = n - 256 end return n end
function self:Int8BE () local n = self.File:ReadByte () or 0 if n >= 128 then n = n - 256 end return n end

function self:UInt16LE () local n = self.File:ReadShort () or 0 if n < 0 then n = n + 65536 end return n end

function self:Int16LE () return self.File:ReadShort () or 0 end

function self:UInt32LE () local n = self.File:ReadLong () or 0 if n < 0 then n = n + 4294967296 end return n end

function self:Int32LE () return self.File:ReadLong () or 0 end

function self:FloatLE  () return self.File:ReadFloat  () or 0 end
function self:DoubleLE () return self.File:ReadDouble () or 0 end

-- StreamReader
function self:UInt81 ()
	local uint8 = self.File:ReadByte () or 0
	local uint80 = BitConverter.UInt8ToUInt8s (uint8)
	return uint80
end

function self:UInt82 ()
	local int16 = self.File:ReadShort () or 0
	local uint80, uint81 = BitConverter.Int16ToUInt8s (int16)
	return uint80, uint81
end

function self:UInt84 ()
	local int32 = self.File:ReadLong () or 0
	local uint80, uint81, uint82, uint83 = BitConverter.Int32ToUInt8s (int32)
	return uint80, uint81, uint82, uint83
end

function self:UInt88 ()
	local uint80, uint81, uint82, uint83 = self:UInt84 ()
	local uint84, uint85, uint86, uint87 = self:UInt84 ()
	return uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87
end
