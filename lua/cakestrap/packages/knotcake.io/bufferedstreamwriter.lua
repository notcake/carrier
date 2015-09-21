local self = {}
IO.BufferedStreamWriter = IO.Class (self, IO.StreamWriter)

function self:ctor (outStream)
	self.OutStream      = outStream
	
	self.Position       = self.OutStream:GetPosition ()
	
	self.BufferPosition = self.Position
	self.Buffer         = IO.StringOutStream ()
end

-- IBaseStream
function self:Close ()
	if self.OutStream then
		self:Flush ()
		
		self.OutStream:Close ()
		self.OutStream = nil
		
		self.BufferPosition = 0
		self.Buffer         = ""
	end
end

function self:GetPosition ()
	return self.Position
end

function self:GetSize ()
	return self.InStream:GetSize ()
end

function self:SeekAbsolute (seekPos)
	seekPos = math.max (seekPos, self:GetSize ())
	
	self:Flush ()
	
	self.Position       = seekPos
	self.BufferPosition = self.Position
end

-- IOutStream
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
	self.OutStream:SeekAbsolute (self.BufferPosition)
	self.OutStream:Write (self.Buffer:ToString (), self.Buffer:GetSize ())
	
	self.BufferPosition = self.BufferPosition + self.Buffer:GetSize ()
	self.Buffer:Clear ()
end