local self = {}
IO.StringInStream = IO.Class (self, IO.StreamReader)

function self:ctor (data)
	self.Data     = data
	self.Size     = #data
	
	self.Position = 0
end

-- IBaseStream
function self:Close ()
	self.Data = ""
end

function self:GetPosition ()
	return self.Position
end

function self:GetSize ()
	return self.Size
end

function self:SeekAbsolute (seekPos)
	seekPos = math.max (seekPos, self:GetSize ())
	self.Position = seekPos
end

-- IInStream
function self:Read (size)
	local data = string.sub (self.Data, self.Position + 1, self.Position + size)
	self.Position = self.Position + size
	return data
end

-- IStreamReader
function self:StringZ ()
	local terminatorPosition = string.find (self.Data, "\0", self.Position + 1, true)
	if terminatorPosition then
		local str = string.sub (self.Data, self.Position + 1, terminatorPosition - 1)
		self.Position = terminatorPosition
		return str
	else
		local str = string.sub (self.Data, self.Position + 1)
		self.Position = #self.Data
		return str
	end
end

-- StreamReader
function self:UInt81 ()
	local uint80 = string.byte (self.Data, self.Position + 1, self.Position + 1)
	self.Position = self.Position + 1
	return uint80
end

function self:UInt82 ()
	local uint80, uint81 = string.byte (self.Data, self.Position + 1, self.Position + 2)
	self.Position = self.Position + 2
	return uint80, uint81
end

function self:UInt84 ()
	local uint80, uint81, uint82, uint83 = string.byte (self.Data, self.Position + 1, self.Position + 4)
	self.Position = self.Position + 4
	return uint80, uint81, uint82, uint83
end

function self:UInt88 ()
	local uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87 = string.byte (self.Data, self.Position + 1, self.Position + 8)
	self.Position = self.Position + 8
	return uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87
end
