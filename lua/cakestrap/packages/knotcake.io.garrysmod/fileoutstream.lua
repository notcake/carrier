local self = {}
GarrysMod.FileOutStream = GarrysMod.Class (self, GarrysMod.IO.StreamWriter)

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

-- IOutStream
function self:Write (data, size)
	size = size or #data
	
	if size < #data then
		data = string.sub (data, 1, size)
	end
	
	self.File:Write (data)
end	

-- StreamWriter
function self:UInt81 (uint80)
	local uint8 = GarrysMod.BitConverter.UInt8sToUInt8 (uint80)
	self.File:WriteByte (uint8)
end

function self:UInt82 (uint80, uint81)
	local int16 = GarrysMod.BitConverter.UInt8sToInt16 (uint80, uint81)
	self.File:WriteShort (int16)
end

function self:UInt84 (uint80, uint81, uint82, uint83)
	local int32 = GarrysMod.BitConverter.UInt8sToInt32 (uint80, uint81, uint82, uint83)
	self.File:WriteLong (int32)
end

function self:UInt88 (uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87)
	self:UInt84 (uint80, uint81, uint82, uint83)
	self:UInt84 (uint84, uint85, uint86, uint87)
end
