local self = {}
IO.StreamReader = Class (self, IO.IStreamReader)

local string_char = string.char

function self:ctor ()
	self.Endianness = nil
	
	self:SetEndianness (IO.Endianness.LittleEndian)
end

-- IStreamReader
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

function self:UInt8    () local uint80 = self:UInt81 () return BitConverter.UInt8sToUInt8 (uint80 or 0) end
function self:UInt8LE  () local uint80 = self:UInt81 () return BitConverter.UInt8sToUInt8 (uint80 or 0) end
function self:UInt8BE  () local uint80 = self:UInt81 () return BitConverter.UInt8sToUInt8 (uint80 or 0) end
function self:Int8     () local uint80 = self:UInt81 () return BitConverter.UInt8sToInt8  (uint80 or 0) end
function self:Int8LE   () local uint80 = self:UInt81 () return BitConverter.UInt8sToInt8  (uint80 or 0) end
function self:Int8BE   () local uint80 = self:UInt81 () return BitConverter.UInt8sToInt8  (uint80 or 0) end

function self:UInt16LE () local uint80, uint81 = self:UInt82 () return BitConverter.UInt8sToUInt16 (uint80 or 0, uint81 or 0) end
function self:UInt16BE () local uint80, uint81 = self:UInt82 () return BitConverter.UInt8sToUInt16 (uint81 or 0, uint80 or 0) end
function self:Int16LE  () local uint80, uint81 = self:UInt82 () return BitConverter.UInt8sToInt16  (uint80 or 0, uint81 or 0) end
function self:Int16BE  () local uint80, uint81 = self:UInt82 () return BitConverter.UInt8sToInt16  (uint81 or 0, uint80 or 0) end

function self:UInt32LE () local uint80, uint81, uint82, uint83 = self:UInt84 () return BitConverter.UInt8sToUInt32 (uint80 or 0, uint81 or 0, uint82 or 0, uint83 or 0) end
function self:UInt32BE () local uint80, uint81, uint82, uint83 = self:UInt84 () return BitConverter.UInt8sToUInt32 (uint83 or 0, uint82 or 0, uint81 or 0, uint80 or 0) end
function self:Int32LE  () local uint80, uint81, uint82, uint83 = self:UInt84 () return BitConverter.UInt8sToInt32  (uint80 or 0, uint81 or 0, uint82 or 0, uint83 or 0) end
function self:Int32BE  () local uint80, uint81, uint82, uint83 = self:UInt84 () return BitConverter.UInt8sToInt32  (uint83 or 0, uint82 or 0, uint81 or 0, uint80 or 0) end

function self:UInt64LE () local uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87 = self:UInt88 () return BitConverter.UInt8sToUInt64 (uint80 or 0, uint81 or 0, uint82 or 0, uint83 or 0, uint84 or 0, uint85 or 0, uint86 or 0, uint87 or 0) end
function self:UInt64BE () local uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87 = self:UInt88 () return BitConverter.UInt8sToUInt64 (uint87 or 0, uint86 or 0, uint85 or 0, uint84 or 0, uint83 or 0, uint82 or 0, uint81 or 0, uint80 or 0) end
function self:Int64LE  () local uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87 = self:UInt88 () return BitConverter.UInt8sToInt64  (uint80 or 0, uint81 or 0, uint82 or 0, uint83 or 0, uint84 or 0, uint85 or 0, uint86 or 0, uint87 or 0) end
function self:Int64BE  () local uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87 = self:UInt88 () return BitConverter.UInt8sToInt64  (uint87 or 0, uint86 or 0, uint85 or 0, uint84 or 0, uint83 or 0, uint82 or 0, uint81 or 0, uint80 or 0) end

function self:FloatLE () return BitConverter.UInt32ToFloat (self:UInt32LE ()) end
function self:FloatBE () return BitConverter.UInt32ToFloat (self:UInt32BE ()) end

function self:DoubleLE ()
	local low  = self:UInt32LE ()
	local high = self:UInt32LE ()
	return BitConverter.UInt32sToDouble (low, high)
end

function self:DoubleBE ()
	local high = self:UInt32BE ()
	local low  = self:UInt32BE ()
	return BitConverter.UInt32sToDouble (low, high)
end

function self:Boolean ()
	return self:UInt8 () ~= 0
end

function self:Bytes (length)
	return self:Read (length)
end

function self:StringN8LE  () return self:Bytes (self:UInt8LE  ()) end
function self:StringN16LE () return self:Bytes (self:UInt16LE ()) end
function self:StringN32LE () return self:Bytes (self:UInt32LE ()) end
function self:StringN8BE  () return self:Bytes (self:UInt8BE  ()) end
function self:StringN16BE () return self:Bytes (self:UInt16BE ()) end
function self:StringN32BE () return self:Bytes (self:UInt32BE ()) end

function self:StringZ ()
	local data = ""
	local c = self:UInt8 ()
	while c and c ~= 0 do
		if #data > 65536 then
			Error ("StreamReader:StringZ : String is too long, infinite loop?")
			break
		end
		
		data = data .. string_char (c)
		c = self:UInt8 ()
	end
	
	return data
end

-- StreamReader
-- Internal, do not call
function self:UInt81 () Error ("StreamReader:UInt81 : Not implemented.") end
function self:UInt82 () Error ("StreamReader:UInt82 : Not implemented.") end
function self:UInt84 () Error ("StreamReader:UInt84 : Not implemented.") end
function self:UInt88 () Error ("StreamReader:UInt88 : Not implemented.") end
