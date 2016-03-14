local self = {}
IO.StringOutStream = Class (self, IO.StreamWriter)

function self:ctor ()
	self.Data     = {}
	self.Position = 0
	self.Size     = 0
end

-- IBaseStream
function self:Close ()
	self.Data = {}
end

function self:GetPosition ()
	return self.Position
end

function self:GetSize ()
	return self.Size
end

function self:SeekAbsolute (seekPos)
	Error ("IO.StringOutStream:SeekAbsolute : Not implemented.")
end

-- IOutStream
function self:Write (data, length)
	length = length or #data
	
	if length < #data then
		data = string.sub (data, 1, length)
	end
	
	self.Data [#self.Data + 1] = data
	self.Size     = self.Size     + length
	self.Position = self.Position + length
end

-- StreamWriter
function self:UInt81 (uint80)
	self.Data [#self.Data + 1] = string.char (uint80)
	self.Size     = self.Size     + 1
	self.Position = self.Position + 1
end

function self:UInt82 (uint80, uint81)
	self.Data [#self.Data + 1] = string.char (uint80, uint81)
	self.Size     = self.Size     + 2
	self.Position = self.Position + 2
end

function self:UInt84 (uint80, uint81, uint82, uint83)
	self.Data [#self.Data + 1] = string.char (uint80, uint81, uint82, uint83)
	self.Size     = self.Size     + 4
	self.Position = self.Position + 4
end

function self:UInt88 (uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87)
	self.Data [#self.Data + 1] = string.char (uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87)
	self.Size     = self.Size     + 8
	self.Position = self.Position + 8
end

-- StringOutStream
function self:Clear ()
	self.Data     = {}
	self.Position = 0
	self.Size     = 0
end

function self:ToString ()
	if #self.Data > 1 then
		self.Data = { table.concat (self.Data) }
	end
	
	return self.Data [1] or ""
end
