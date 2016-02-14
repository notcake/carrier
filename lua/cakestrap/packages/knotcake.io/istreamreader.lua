local self = {}
IO.IStreamReader = IO.Class (self, IO.IInStream)

function self:ctor ()
end

-- IInStream
function self:ToStreamReader ()
	return self
end

-- IStreamReader
function self:GetEndianness ()
	IO.Error ("IStreamReader:GetEndianness : Not implemented.")
end

function self:SetEndianness (endianness)
	IO.Error ("IStreamReader:SetEndianness : Not implemented.")
end

function self:UInt8    () IO.Error ("IStreamReader:UInt8 : Not implemented.")    end
function self:UInt16   () IO.Error ("IStreamReader:UInt16 : Not implemented.")   end
function self:UInt32   () IO.Error ("IStreamReader:UInt32 : Not implemented.")   end
function self:UInt64   () IO.Error ("IStreamReader:UInt64 : Not implemented.")   end

function self:Int8     () IO.Error ("IStreamReader:Int8 : Not implemented.")     end
function self:Int16    () IO.Error ("IStreamReader:Int16 : Not implemented.")    end
function self:Int32    () IO.Error ("IStreamReader:Int32 : Not implemented.")    end
function self:Int64    () IO.Error ("IStreamReader:Int64 : Not implemented.")    end

function self:UInt8LE  () IO.Error ("IStreamReader:UInt8LE : Not implemented.")  end
function self:UInt16LE () IO.Error ("IStreamReader:UInt16LE : Not implemented.") end
function self:UInt32LE () IO.Error ("IStreamReader:UInt32LE : Not implemented.") end
function self:UInt64LE () IO.Error ("IStreamReader:UInt64LE : Not implemented.") end

function self:Int8LE   () IO.Error ("IStreamReader:Int8LE : Not implemented.")   end
function self:Int16LE  () IO.Error ("IStreamReader:Int16LE : Not implemented.")  end
function self:Int32LE  () IO.Error ("IStreamReader:Int32LE : Not implemented.")  end
function self:Int64LE  () IO.Error ("IStreamReader:Int64LE : Not implemented.")  end

function self:UInt8BE  () IO.Error ("IStreamReader:UInt8BE : Not implemented.")  end
function self:UInt16BE () IO.Error ("IStreamReader:UInt16BE : Not implemented.") end
function self:UInt32BE () IO.Error ("IStreamReader:UInt32BE : Not implemented.") end
function self:UInt64BE () IO.Error ("IStreamReader:UInt64BE : Not implemented.") end

function self:Int8BE   () IO.Error ("IStreamReader:Int8BE : Not implemented.")   end
function self:Int16BE  () IO.Error ("IStreamReader:Int16BE : Not implemented.")  end
function self:Int32BE  () IO.Error ("IStreamReader:Int32BE : Not implemented.")  end
function self:Int64BE  () IO.Error ("IStreamReader:Int64BE : Not implemented.")  end

function self:Float    () IO.Error ("IStreamReader:Float : Not implemented.")    end
function self:Double   () IO.Error ("IStreamReader:Double : Not implemented.")   end

function self:FloatLE  () IO.Error ("IStreamReader:FloatLE : Not implemented.")  end
function self:DoubleLE () IO.Error ("IStreamReader:DoubleLE : Not implemented.") end

function self:FloatBE  () IO.Error ("IStreamReader:FloatBE : Not implemented.")  end
function self:DoubleBE () IO.Error ("IStreamReader:DoubleBE : Not implemented.") end

function self:Boolean  () IO.Error ("IStreamReader:Boolean : Not implemented.")  end

function self:Bytes (length)
	IO.Error ("IStreamReader:Bytes : Not implemented.")
end

function self:StringN8    () IO.Error ("IStreamReader:StringN8 : Not implemented.")    end
function self:StringN16   () IO.Error ("IStreamReader:StringN16 : Not implemented.")   end
function self:StringN32   () IO.Error ("IStreamReader:StringN32 : Not implemented.")   end

function self:StringN8LE  () IO.Error ("IStreamReader:StringN8LE : Not implemented.")  end
function self:StringN16LE () IO.Error ("IStreamReader:StringN16LE : Not implemented.") end
function self:StringN32LE () IO.Error ("IStreamReader:StringN32LE : Not implemented.") end

function self:StringN8BE  () IO.Error ("IStreamReader:StringN8BE : Not implemented.")  end
function self:StringN16BE () IO.Error ("IStreamReader:StringN16BE : Not implemented.") end
function self:StringN32BE () IO.Error ("IStreamReader:StringN32BE : Not implemented.") end

function self:StringZ     () IO.Error ("IStreamReader:StringZ : Not implemented.")     end
