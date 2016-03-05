local self = {}
IO.IStreamReader = Class (self, IO.IInStream)

function self:ctor ()
end

-- IInStream
function self:ToStreamReader ()
	return self
end

-- IStreamReader
function self:GetEndianness ()
	Error ("IStreamReader:GetEndianness : Not implemented.")
end

function self:SetEndianness (endianness)
	Error ("IStreamReader:SetEndianness : Not implemented.")
end

function self:UInt8    () Error ("IStreamReader:UInt8 : Not implemented.")    end
function self:UInt16   () Error ("IStreamReader:UInt16 : Not implemented.")   end
function self:UInt32   () Error ("IStreamReader:UInt32 : Not implemented.")   end
function self:UInt64   () Error ("IStreamReader:UInt64 : Not implemented.")   end

function self:Int8     () Error ("IStreamReader:Int8 : Not implemented.")     end
function self:Int16    () Error ("IStreamReader:Int16 : Not implemented.")    end
function self:Int32    () Error ("IStreamReader:Int32 : Not implemented.")    end
function self:Int64    () Error ("IStreamReader:Int64 : Not implemented.")    end

function self:UInt8LE  () Error ("IStreamReader:UInt8LE : Not implemented.")  end
function self:UInt16LE () Error ("IStreamReader:UInt16LE : Not implemented.") end
function self:UInt32LE () Error ("IStreamReader:UInt32LE : Not implemented.") end
function self:UInt64LE () Error ("IStreamReader:UInt64LE : Not implemented.") end

function self:Int8LE   () Error ("IStreamReader:Int8LE : Not implemented.")   end
function self:Int16LE  () Error ("IStreamReader:Int16LE : Not implemented.")  end
function self:Int32LE  () Error ("IStreamReader:Int32LE : Not implemented.")  end
function self:Int64LE  () Error ("IStreamReader:Int64LE : Not implemented.")  end

function self:UInt8BE  () Error ("IStreamReader:UInt8BE : Not implemented.")  end
function self:UInt16BE () Error ("IStreamReader:UInt16BE : Not implemented.") end
function self:UInt32BE () Error ("IStreamReader:UInt32BE : Not implemented.") end
function self:UInt64BE () Error ("IStreamReader:UInt64BE : Not implemented.") end

function self:Int8BE   () Error ("IStreamReader:Int8BE : Not implemented.")   end
function self:Int16BE  () Error ("IStreamReader:Int16BE : Not implemented.")  end
function self:Int32BE  () Error ("IStreamReader:Int32BE : Not implemented.")  end
function self:Int64BE  () Error ("IStreamReader:Int64BE : Not implemented.")  end

function self:Float    () Error ("IStreamReader:Float : Not implemented.")    end
function self:Double   () Error ("IStreamReader:Double : Not implemented.")   end

function self:FloatLE  () Error ("IStreamReader:FloatLE : Not implemented.")  end
function self:DoubleLE () Error ("IStreamReader:DoubleLE : Not implemented.") end

function self:FloatBE  () Error ("IStreamReader:FloatBE : Not implemented.")  end
function self:DoubleBE () Error ("IStreamReader:DoubleBE : Not implemented.") end

function self:Boolean  () Error ("IStreamReader:Boolean : Not implemented.")  end

function self:Bytes (length)
	Error ("IStreamReader:Bytes : Not implemented.")
end

function self:StringN8    () Error ("IStreamReader:StringN8 : Not implemented.")    end
function self:StringN16   () Error ("IStreamReader:StringN16 : Not implemented.")   end
function self:StringN32   () Error ("IStreamReader:StringN32 : Not implemented.")   end

function self:StringN8LE  () Error ("IStreamReader:StringN8LE : Not implemented.")  end
function self:StringN16LE () Error ("IStreamReader:StringN16LE : Not implemented.") end
function self:StringN32LE () Error ("IStreamReader:StringN32LE : Not implemented.") end

function self:StringN8BE  () Error ("IStreamReader:StringN8BE : Not implemented.")  end
function self:StringN16BE () Error ("IStreamReader:StringN16BE : Not implemented.") end
function self:StringN32BE () Error ("IStreamReader:StringN32BE : Not implemented.") end

function self:StringZ     () Error ("IStreamReader:StringZ : Not implemented.")     end
