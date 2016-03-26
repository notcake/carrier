local self = {}
IO.IStreamWriter = Class (self, IO.IOutputStream)

function self:ctor ()
end

-- IOutputStream
function self:ToStreamWriter ()
	return self
end

-- IStreamWriter
function self:GetEndianness ()
	Error ("IStreamWriter:GetEndianness : Not implemented.")
end

function self:SetEndianness (endianness)
	Error ("IStreamWriter:SetEndianness : Not implemented.")
end

function self:UInt8    (n) Error ("IStreamWriter:UInt8 : Not implemented.")    end
function self:UInt16   (n) Error ("IStreamWriter:UInt16 : Not implemented.")   end
function self:UInt32   (n) Error ("IStreamWriter:UInt32 : Not implemented.")   end
function self:UInt64   (n) Error ("IStreamWriter:UInt64 : Not implemented.")   end

function self:Int8     (n) Error ("IStreamWriter:Int8 : Not implemented.")     end
function self:Int16    (n) Error ("IStreamWriter:Int16 : Not implemented.")    end
function self:Int32    (n) Error ("IStreamWriter:Int32 : Not implemented.")    end
function self:Int64    (n) Error ("IStreamWriter:Int64 : Not implemented.")    end

function self:UInt8LE  (n) Error ("IStreamWriter:UInt8LE : Not implemented.")  end
function self:UInt16LE (n) Error ("IStreamWriter:UInt16LE : Not implemented.") end
function self:UInt32LE (n) Error ("IStreamWriter:UInt32LE : Not implemented.") end
function self:UInt64LE (n) Error ("IStreamWriter:UInt64LE : Not implemented.") end

function self:Int8LE   (n) Error ("IStreamWriter:Int8LE : Not implemented.")   end
function self:Int16LE  (n) Error ("IStreamWriter:Int16LE : Not implemented.")  end
function self:Int32LE  (n) Error ("IStreamWriter:Int32LE : Not implemented.")  end
function self:Int64LE  (n) Error ("IStreamWriter:Int64LE : Not implemented.")  end

function self:UInt8BE  (n) Error ("IStreamWriter:UInt8BE : Not implemented.")  end
function self:UInt16BE (n) Error ("IStreamWriter:UInt16BE : Not implemented.") end
function self:UInt32BE (n) Error ("IStreamWriter:UInt32BE : Not implemented.") end
function self:UInt64BE (n) Error ("IStreamWriter:UInt64BE : Not implemented.") end

function self:Int8BE   (n) Error ("IStreamWriter:Int8BE : Not implemented.")   end
function self:Int16BE  (n) Error ("IStreamWriter:Int16BE : Not implemented.")  end
function self:Int32BE  (n) Error ("IStreamWriter:Int32BE : Not implemented.")  end
function self:Int64BE  (n) Error ("IStreamWriter:Int64BE : Not implemented.")  end

function self:Float    (f) Error ("IStreamWriter:Float : Not implemented.")    end
function self:Double   (f) Error ("IStreamWriter:Double : Not implemented.")   end

function self:FloatLE  (f) Error ("IStreamWriter:FloatLE : Not implemented.")  end
function self:DoubleLE (f) Error ("IStreamWriter:DoubleLE : Not implemented.") end

function self:FloatBE  (f) Error ("IStreamWriter:FloatBE : Not implemented.")  end
function self:DoubleBE (f) Error ("IStreamWriter:DoubleBE : Not implemented.") end

function self:Boolean  (b) Error ("IStreamWriter:Boolean : Not implemented.")  end

function self:Bytes (data, length)
	Error ("IStreamWriter:Bytes : Not implemented.")
end

function self:StringN8    (s) Error ("IStreamWriter:StringN8 : Not implemented.")    end
function self:StringN16   (s) Error ("IStreamWriter:StringN16 : Not implemented.")   end
function self:StringN32   (s) Error ("IStreamWriter:StringN32 : Not implemented.")   end
                              
function self:StringN8LE  (s) Error ("IStreamWriter:StringN8LE : Not implemented.")  end
function self:StringN16LE (s) Error ("IStreamWriter:StringN16LE : Not implemented.") end
function self:StringN32LE (s) Error ("IStreamWriter:StringN32LE : Not implemented.") end
                              
function self:StringN8BE  (s) Error ("IStreamWriter:StringN8BE : Not implemented.")  end
function self:StringN16BE (s) Error ("IStreamWriter:StringN16BE : Not implemented.") end
function self:StringN32BE (s) Error ("IStreamWriter:StringN32BE : Not implemented.") end
                              
function self:StringZ     (s) Error ("IStreamWriter:StringZ : Not implemented.")     end
