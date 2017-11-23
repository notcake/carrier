local self = {}
GarrysMod.FileOutputStream = Class (self, IO.StreamWriter)

function GarrysMod.FileOutputStream.FromPath (path, pathId)
	local f = file.Open (path, "wb", pathId)
	if not f then return nil end
	
	return GarrysMod.FileOutputStream (f)
end

function self:ctor (file)
	self.File = file
	
	self.Size = 0
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
	self.Size = math.max (self.Size, self:GetPosition ())
	return self.Size
end

function self:SeekAbsolute (seekPos)
	seekPos = math.min (seekPos, self:GetSize ())
	self.File:Seek (seekPos)
end

-- IOutputStream
function self:Write (data, length)
	length = length or #data
	
	if length < #data then
		data = string.sub (data, 1, length)
	end
	
	self.File:Write (data)
end	

-- IStreamWriter
function self:UInt8   (n) self.File:WriteByte (n) end
function self:UInt8LE (n) self.File:WriteByte (n) end
function self:UInt8BE (n) self.File:WriteByte (n) end

function self:Int8   (n) if n < 0 then n = n + 256 end self.File:WriteByte (n) end
function self:Int8LE (n) if n < 0 then n = n + 256 end self.File:WriteByte (n) end
function self:Int8BE (n) if n < 0 then n = n + 256 end self.File:WriteByte (n) end

function self:UInt16LE (n) if n >= 32768 then n = n - 65536 end self.File:WriteShort (n) end

function self:Int16LE (n) self.File:WriteShort (n) end

function self:UInt32LE (n) if n >= 2147483648 then n = n - 4294967296 end self.File:WriteLong (n) end

function self:Int32LE (n) self.File:WriteLong (n) end

function self:FloatLE  (f) self.File:WriteFloat  (f) end
function self:DoubleLE (f) self.File:WriteDouble (f) end

-- StreamWriter
function self:UInt81 (uint80)
	local uint8 = BitConverter.UInt8sToUInt8 (uint80)
	self.File:WriteByte (uint8)
end

function self:UInt82 (uint80, uint81)
	local int16 = BitConverter.UInt8sToInt16 (uint80, uint81)
	self.File:WriteShort (int16)
end

function self:UInt84 (uint80, uint81, uint82, uint83)
	local int32 = BitConverter.UInt8sToInt32 (uint80, uint81, uint82, uint83)
	self.File:WriteLong (int32)
end

function self:UInt88 (uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87)
	self:UInt84 (uint80, uint81, uint82, uint83)
	self:UInt84 (uint84, uint85, uint86, uint87)
end
