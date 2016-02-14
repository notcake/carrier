local self = {}
IO.IStreamWriter = IO.Class (self, IO.IOutStream)

function self:ctor ()
end

-- IOutStream
function self:ToStreamWriter ()
	return self
end

-- IStreamWriter
function self:GetEndianness ()
	IO.Error ("IStreamWriter:GetEndianness : Not implemented.")
end

function self:SetEndianness (endianness)
	IO.Error ("IStreamWriter:SetEndianness : Not implemented.")
end

function self:UInt8    (n) IO.Error ("IStreamWriter:UInt8 : Not implemented.")    end
function self:UInt16   (n) IO.Error ("IStreamWriter:UInt16 : Not implemented.")   end
function self:UInt32   (n) IO.Error ("IStreamWriter:UInt32 : Not implemented.")   end
function self:UInt64   (n) IO.Error ("IStreamWriter:UInt64 : Not implemented.")   end

function self:Int8     (n) IO.Error ("IStreamWriter:Int8 : Not implemented.")     end
function self:Int16    (n) IO.Error ("IStreamWriter:Int16 : Not implemented.")    end
function self:Int32    (n) IO.Error ("IStreamWriter:Int32 : Not implemented.")    end
function self:Int64    (n) IO.Error ("IStreamWriter:Int64 : Not implemented.")    end

function self:UInt8LE  (n) IO.Error ("IStreamWriter:UInt8LE : Not implemented.")  end
function self:UInt16LE (n) IO.Error ("IStreamWriter:UInt16LE : Not implemented.") end
function self:UInt32LE (n) IO.Error ("IStreamWriter:UInt32LE : Not implemented.") end
function self:UInt64LE (n) IO.Error ("IStreamWriter:UInt64LE : Not implemented.") end

function self:Int8LE   (n) IO.Error ("IStreamWriter:Int8LE : Not implemented.")   end
function self:Int16LE  (n) IO.Error ("IStreamWriter:Int16LE : Not implemented.")  end
function self:Int32LE  (n) IO.Error ("IStreamWriter:Int32LE : Not implemented.")  end
function self:Int64LE  (n) IO.Error ("IStreamWriter:Int64LE : Not implemented.")  end

function self:UInt8BE  (n) IO.Error ("IStreamWriter:UInt8BE : Not implemented.")  end
function self:UInt16BE (n) IO.Error ("IStreamWriter:UInt16BE : Not implemented.") end
function self:UInt32BE (n) IO.Error ("IStreamWriter:UInt32BE : Not implemented.") end
function self:UInt64BE (n) IO.Error ("IStreamWriter:UInt64BE : Not implemented.") end

function self:Int8BE   (n) IO.Error ("IStreamWriter:Int8BE : Not implemented.")   end
function self:Int16BE  (n) IO.Error ("IStreamWriter:Int16BE : Not implemented.")  end
function self:Int32BE  (n) IO.Error ("IStreamWriter:Int32BE : Not implemented.")  end
function self:Int64BE  (n) IO.Error ("IStreamWriter:Int64BE : Not implemented.")  end

function self:Float    (f) IO.Error ("IStreamWriter:Float : Not implemented.")    end
function self:Double   (f) IO.Error ("IStreamWriter:Double : Not implemented.")   end

function self:FloatLE  (f) IO.Error ("IStreamWriter:FloatLE : Not implemented.")  end
function self:DoubleLE (f) IO.Error ("IStreamWriter:DoubleLE : Not implemented.") end

function self:FloatBE  (f) IO.Error ("IStreamWriter:FloatBE : Not implemented.")  end
function self:DoubleBE (f) IO.Error ("IStreamWriter:DoubleBE : Not implemented.") end

function self:Boolean  (b) IO.Error ("IStreamWriter:Boolean : Not implemented.")  end

function self:Bytes (data, length)
	IO.Error ("IStreamWriter:Bytes : Not implemented.")
end

function self:StringN8    (s) IO.Error ("IStreamWriter:StringN8 : Not implemented.")    end
function self:StringN16   (s) IO.Error ("IStreamWriter:StringN16 : Not implemented.")   end
function self:StringN32   (s) IO.Error ("IStreamWriter:StringN32 : Not implemented.")   end

function self:StringN8LE  (s) IO.Error ("IStreamWriter:StringN8LE : Not implemented.")  end
function self:StringN16LE (s) IO.Error ("IStreamWriter:StringN16LE : Not implemented.") end
function self:StringN32LE (s) IO.Error ("IStreamWriter:StringN32LE : Not implemented.") end

function self:StringN8BE  (s) IO.Error ("IStreamWriter:StringN8BE : Not implemented.")  end
function self:StringN16BE (s) IO.Error ("IStreamWriter:StringN16BE : Not implemented.") end
function self:StringN32BE (s) IO.Error ("IStreamWriter:StringN32BE : Not implemented.") end

function self:StringZ     (s) IO.Error ("IStreamWriter:StringZ : Not implemented.")     end
