local self = {}
IO.BufferedStreamWriter = Class (self, IO.StreamWriter)

function self:ctor (outputStream)
	self.OutputStream   = outputStream
	
	self.BufferPosition = self.OutputStream:GetPosition ()
	self.Buffer         = IO.StringOutputStream ()
end

-- IBaseStream
function self:Close ()
	if self.OutputStream then
		self:Flush ()
		
		self.OutputStream:Close ()
		self.OutputStream = nil
		
		self.BufferPosition = 0
		self.Buffer:Close ()
	end
end

function self:GetPosition ()
	return self.BufferPosition + self.Buffer:GetPosition ()
end

function self:GetSize ()
	return math.max (self.OutputStream:GetSize (), self:GetPosition ())
end

function self:SeekAbsolute (seekPos)
	seekPos = math.min (seekPos, self:GetSize ())
	
	self:Flush ()
	
	self.BufferPosition = seekPos
end

-- IOutputStream
function self:Write (data, size)
	self.Buffer:Write (data, size)
end

-- StreamWriter
function self:UInt81 (uint80)
	self.Buffer:UInt81 (uint80)
end

function self:UInt82 (uint80, uint81)
	self.Buffer:UInt82 (uint80, uint81)
end

function self:UInt84 (uint80, uint81, uint82, uint83)
	self.Buffer:UInt84 (uint80, uint81, uint82, uint83)
end

function self:UInt88 (uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87)
	self.Buffer:UInt88 (uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87)
end

-- Internal, do not call
function self:Flush ()
	self.OutputStream:SeekAbsolute (self.BufferPosition)
	self.OutputStream:Write (self.Buffer:ToString (), self.Buffer:GetSize ())
	
	self.BufferPosition = self.BufferPosition + self.Buffer:GetSize ()
	self.Buffer:Clear ()
end
