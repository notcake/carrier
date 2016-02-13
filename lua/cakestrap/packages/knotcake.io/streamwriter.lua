local self = {}
IO.StreamWriter = IO.Class (self, IO.IStreamWriter)

local string_byte = string.byte

function self:ctor ()
	self.Endianness = nil
	
	self:SetEndianness (IO.Endianness.LittleEndian)
end

-- IStreamWriter
function self:GetEndianness ()
	return self.Endianness
end

function self:SetEndianness (endianness)
	if self.Endianness == endianness then return self end
	
	self.Endianness = endianness
	
	if self.Endianness == IO.Endianness.LittleEndian then
		self.UInt16    = self.UInt16LE
		self.UInt32    = self.UInt32LE
		self.UInt64    = self.UInt64LE
		self.Int16     = self.Int16LE
		self.Int32     = self.Int32LE
		self.Int64     = self.Int64LE
		self.Float     = self.FloatLE
		self.Double    = self.DoubleLE
		self.StringN8  = self.StringN8LE
		self.StringN16 = self.StringN16LE
		self.StringN32 = self.StringN32LE
	else
		self.UInt16    = self.UInt16BE
		self.UInt32    = self.UInt32BE
		self.UInt64    = self.UInt64BE
		self.Int16     = self.Int16BE
		self.Int32     = self.Int32BE
		self.Int64     = self.Int64BE
		self.Float     = self.FloatBE
		self.Double    = self.DoubleBE
		self.StringN8  = self.StringN8BE
		self.StringN16 = self.StringN16BE
		self.StringN32 = self.StringN32BE
	end
	
	return self
end

function self:UInt8    (n) local uint80 = IO.BitConverter.UInt8ToUInt8s (n) self:UInt81 (uint80) end
function self:UInt8LE  (n) local uint80 = IO.BitConverter.UInt8ToUInt8s (n) self:UInt81 (uint80) end
function self:UInt8BE  (n) local uint80 = IO.BitConverter.UInt8ToUInt8s (n) self:UInt81 (uint80) end
function self:Int8     (n) local uint80 = IO.BitConverter.Int8ToUInt8s  (n) self:UInt81 (uint80) end
function self:Int8LE   (n) local uint80 = IO.BitConverter.Int8ToUInt8s  (n) self:UInt81 (uint80) end
function self:Int8BE   (n) local uint80 = IO.BitConverter.Int8ToUInt8s  (n) self:UInt81 (uint80) end

function self:UInt16LE (n) local uint80, uint81 = IO.BitConverter.UInt16ToUInt8s (n) self:UInt82 (uint80, uint81) end
function self:UInt16BE (n) local uint80, uint81 = IO.BitConverter.UInt16ToUInt8s (n) self:UInt82 (uint81, uint80) end
function self:Int16LE  (n) local uint80, uint81 = IO.BitConverter.Int16ToUInt8s  (n) self:UInt82 (uint80, uint81) end
function self:Int16BE  (n) local uint80, uint81 = IO.BitConverter.Int16ToUInt8s  (n) self:UInt82 (uint81, uint80) end

function self:UInt32LE (n) local uint80, uint81, uint82, uint83 = IO.BitConverter.UInt32ToUInt8s (n) self:UInt84 (uint80, uint81, uint82, uint83) end
function self:UInt32BE (n) local uint80, uint81, uint82, uint83 = IO.BitConverter.UInt32ToUInt8s (n) self:UInt84 (uint83, uint82, uint81, uint80) end
function self:Int32LE  (n) local uint80, uint81, uint82, uint83 = IO.BitConverter.Int32ToUInt8s  (n) self:UInt84 (uint80, uint81, uint82, uint83) end
function self:Int32BE  (n) local uint80, uint81, uint82, uint83 = IO.BitConverter.Int32ToUInt8s  (n) self:UInt84 (uint83, uint82, uint81, uint80) end

function self:UInt64LE (n) local uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87 = IO.BitConverter.UInt64ToUInt8s (n) self:UInt88 (uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87) end
function self:UInt64BE (n) local uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87 = IO.BitConverter.UInt64ToUInt8s (n) self:UInt88 (uint87, uint86, uint85, uint84, uint83, uint82, uint81, uint80) end
function self:Int64LE  (n) local uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87 = IO.BitConverter.Int64ToUInt8s  (n) self:UInt88 (uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87) end
function self:Int64BE  (n) local uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87 = IO.BitConverter.Int64ToUInt8s  (n) self:UInt88 (uint87, uint86, uint85, uint84, uint83, uint82, uint81, uint80) end

function self:FloatLE (f) self:UInt32LE (IO.BitConverter.FloatToUInt32 (f)) end
function self:FloatBE (f) self:UInt32BE (IO.BitConverter.FloatToUInt32 (f)) end

function self:DoubleLE (f)
	local low, high = IO.BitConverter.DoubleToUInt32s (f)
	self:UInt32LE (low)
	self:UInt32LE (high)
end

function self:DoubleBE (f)
	local low, high = IO.BitConverter.DoubleToUInt32s (f)
	self:UInt32LE (high)
	self:UInt32LE (low)
end

function self:Char (c)
	return self:UInt81 (string_byte (c))
end

function self:Boolean (b)
	self:UInt8 (b and 1 or 0)
end

function self:Bytes (data, length)
	return self:Write (data, length)
end

function self:StringN8LE  (s) self:UInt8LE  (#s) return self:Bytes (s) end
function self:StringN16LE (s) self:UInt16LE (#s) return self:Bytes (s) end
function self:StringN32LE (s) self:UInt32LE (#s) return self:Bytes (s) end
function self:StringN8BE  (s) self:UInt8BE  (#s) return self:Bytes (s) end
function self:StringN16BE (s) self:UInt16BE (#s) return self:Bytes (s) end
function self:StringN32BE (s) self:UInt32BE (#s) return self:Bytes (s) end

function self:StringZ (s)
	self:Bytes (s)
	self:UInt8 (0x00)
end

-- StreamWriter
-- Internal, do not call
function self:UInt81 (uint80)                                                         IO.Error ("StreamWriter:UInt81 : Not implemented.") end
function self:UInt82 (uint80, uint81)                                                 IO.Error ("StreamWriter:UInt82 : Not implemented.") end
function self:UInt84 (uint80, uint81, uint82, uint83)                                 IO.Error ("StreamWriter:UInt84 : Not implemented.") end
function self:UInt88 (uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87) IO.Error ("StreamWriter:UInt88 : Not implemented.") end
