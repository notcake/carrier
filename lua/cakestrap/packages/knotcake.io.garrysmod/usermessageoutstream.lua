local self = {}
GarrysMod.UsermessageOutStream = Class (self, IO.StreamWriter)

function self:ctor ()
	self.Position = 0
end

-- IBaseStream
function self:Close ()
end

function self:GetPosition ()
	return self.Position
end

function self:GetSize ()
	return self.Position
end

function self:SeekAbsolute (seekPos)
	seekPos = math.max (seekPos, self:GetSize ())
	
	Error ("UsermessageOutStream:SeekAbsolute : Not supported.")
end

-- IOutStream
function self:Write (data, length)
	for i = 1, length do
		self:UInt8 (string.char (data, i))
	end
end	

-- IStreamWriter
function self:UInt8    (n) self.Position = self.Position + 1 if n >= 128 then n = n - 256 end umsg.Char (n) end
function self:UInt8LE  (n) self.Position = self.Position + 1 if n >= 128 then n = n - 256 end umsg.Char (n) end
function self:UInt8BE  (n) self.Position = self.Position + 1 if n >= 128 then n = n - 256 end umsg.Char (n) end

function self:Int8     (n) self.Position = self.Position + 1 umsg.Char (n) end
function self:Int8LE   (n) self.Position = self.Position + 1 umsg.Char (n) end
function self:Int8BE   (n) self.Position = self.Position + 1 umsg.Char (n) end

function self:UInt16LE (n) self.Position = self.Position + 2 if n >= 32768 then n = n - 65536 end umsg.Short (n) end
function self:Int16LE  (n) self.Position = self.Position + 2 umsg.Short (n) end

function self:UInt32LE (n) self.Position = self.Position + 4 if n >= 2147483648 then n = n - 4294967296 end umsg.Long (n) end
function self:Int32LE  (n) self.Position = self.Position + 4 umsg.Long (n) end

function self:FloatLE  (f) self.Position = self.Position + 4 umsg.Float (f) end

-- StreamWriter
function self:UInt81 (uint80)
	self.Position = self.Position + 1
	
	local int8 = BitConverter.UInt8sToInt8 (uint80)
	umsg.Char (int8)
end

function self:UInt82 (uint80, uint81)
	self.Position = self.Position + 2
	
	local int16 = BitConverter.UInt8sToInt16 (uint80, uint81)
	umsg.Short (int16)
end

function self:UInt84 (uint80, uint81, uint82, uint83)
	self.Position = self.Position + 4
	
	local int32 = BitConverter.UInt8sToInt32 (uint80, uint81, uint82, uint83)
	usmg.Long (int32)
end

function self:UInt88 (uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87)
	self:UInt84 (uint80, uint81, uint82, uint83)
	self:UInt84 (uint84, uint85, uint86, uint87)
end
