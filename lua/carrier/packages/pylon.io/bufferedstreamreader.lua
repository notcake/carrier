local self = {}
IO.BufferedStreamReader = Class (self, IO.StreamReader)

function self:ctor (inputStream)
	self.InputStream    = inputStream
	
	self.Position       = self.InputStream:GetPosition ()
	
	self.BufferSize     = 32768
	self.BufferPosition = 0
	self.Buffer         = ""
end

-- IBaseStream
function self:Close ()
	if self.InputStream then
		self.InputStream:Close ()
		self.InputStream = nil
		
		self.BufferPosition = 0
		self.Buffer         = ""
	end
end

function self:GetPosition ()
	return self.Position
end

function self:GetSize ()
	return self.InputStream:GetSize ()
end

function self:SeekAbsolute (seekPos)
	seekPos = math.min (seekPos, self:GetSize ())
	self.Position = seekPos
	
	if self.Position <  self.BufferPosition or
	   self.Position >= self.BufferPosition + #self.Buffer then
		self.BufferPosition = self.BufferSize * math.floor (self.Position / self.BufferSize)
		self.Buffer         = ""
	end
end

-- IInputStream
function self:Read (size)
	local bufferOffset   = self.Position - self.BufferPosition
	local bytesAvailable = #self.Buffer - bufferOffset
	
	if size <= bytesAvailable then
		local data = string.sub (self.Buffer, bufferOffset + 1, bufferOffset + size)
		self.Position = self.Position + size
		return data
	end
	
	local data = {}
	local bytesRead = 0
	
	data [#data + 1] = string.sub (self.Buffer, bufferOffset + 1)
	bytesRead = bytesRead + bytesAvailable
	self.Position = self.Position + bytesAvailable
	
	while bytesRead < size do
		self:NextBlock ()
		if #self.Buffer == 0 then break end
		
		bytesAvailable = #self.Buffer
		if size - bytesRead <= bytesAvailable then
			data [#data + 1] = string.sub (self.Buffer, 1, size - bytesRead)
			self.Position = self.Position + size - bytesRead
			bytesRead = bytesRead + size - bytesRead
		else
			data [#data + 1] = self.Buffer
			self.Position = self.Position + bytesAvailable
			bytesRead = bytesRead + bytesAvailable
		end
	end
	
	return table.concat (data)
end

-- IStreamReader
function self:StringZ ()
	local bufferOffset   = self.Position - self.BufferPosition
	local bytesAvailable = #self.Buffer - bufferOffset
	
	local terminatorPosition = string.find (self.Buffer, "\0", bufferOffset + 1, true)
	if terminatorPosition then
		local str = string.sub (self.Buffer, bufferOffset + 1, terminatorPosition - 1)
		self.Position = self.Position + terminatorPosition - bufferOffset
		return str
	else
		local str = {}
		str [#str + 1] = string.sub (self.Buffer, bufferOffset + 1)
		self.Position = self.Position + bytesAvailable
		
		while true do
			self:NextBlock ()
			if #self.Buffer == 0 then break end
			
			terminatorPosition = string.find (self.Buffer, "\0", 1, true)
			if terminatorPosition then
				str [#str + 1] = string.sub (self.Buffer, 1, terminatorPosition - 1)
				self.Position = self.Position + terminatorPosition
				break
			else
				str [#str + 1] = self.Buffer
				self.Position = self.Position + #self.Buffer
			end
		end
		
		return table.concat (str)
	end
end

-- StreamReader
function self:UInt81 ()
	local bufferOffset   = self.Position - self.BufferPosition
	local bytesAvailable = #self.Buffer - bufferOffset
	
	local uint80 = nil
	if bytesAvailable >= 1 then
		uint80 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 1)
	elseif bytesAvailable <= 0 then
		bufferOffset, bytesAvailable = self:NextBlock ()
		uint80 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 1)
	end
	self.Position = self.Position + 1
	
	return uint80
end

function self:UInt82 ()
	local bufferOffset   = self.Position - self.BufferPosition
	local bytesAvailable = #self.Buffer - bufferOffset
	
	local uint80, uint81 = nil, nil
	if bytesAvailable >= 2 then
		uint80, uint81 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 2)
	elseif bytesAvailable == 1 then
		uint80 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 1)
		bufferOffset, bytesAvailable = self:NextBlock ()
		uint81 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 1)
	elseif bytesAvailable <= 0 then
		bufferOffset, bytesAvailable = self:NextBlock ()
		uint80, uint81 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 2)
	end
	self.Position = self.Position + 2
	
	return uint80, uint81
end

function self:UInt84 ()
	local bufferOffset   = self.Position - self.BufferPosition
	local bytesAvailable = #self.Buffer - bufferOffset
	
	local uint80, uint81, uint82, uint83 = nil, nil, nil, nil
	if bytesAvailable >= 4 then
		uint80, uint81, uint82, uint83 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 4)
	elseif bytesAvailable == 3 then
		uint80, uint81, uint82 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 3)
		bufferOffset, bytesAvailable = self:NextBlock ()
		uint83 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 1)
	elseif bytesAvailable == 2 then
		uint80, uint81 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 2)
		bufferOffset, bytesAvailable = self:NextBlock ()
		uint82, uint83 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 2)
	elseif bytesAvailable == 1 then
		uint80 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 1)
		bufferOffset, bytesAvailable = self:NextBlock ()
		uint81, uint82, uint83 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 3)
	elseif bytesAvailable == 0 then
		bufferOffset, bytesAvailable = self:NextBlock ()
		uint80, uint81, uint82, uint83 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 4)
	end
	self.Position = self.Position + 4
	
	return uint80, uint81, uint82, uint83
end

function self:UInt88 ()
	local bufferOffset   = self.Position - self.BufferPosition
	local bytesAvailable = #self.Buffer - bufferOffset
	
	local uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87 = nil, nil, nil, nil, nil, nil, nil, nil
	if bytesAvailable >= 8 then
		uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 8)
	elseif bytesAvailable == 7 then
		uint80, uint81, uint82, uint83, uint84, uint85, uint86 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 7)
		bufferOffset, bytesAvailable = self:NextBlock ()
		uint87 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 1)
	elseif bytesAvailable == 6 then
		uint80, uint81, uint82, uint83, uint84, uint85 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 6)
		bufferOffset, bytesAvailable = self:NextBlock ()
		uint86, uint87 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 2)
	elseif bytesAvailable == 5 then
		uint80, uint81, uint82, uint83, uint84 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 5)
		bufferOffset, bytesAvailable = self:NextBlock ()
		uint85, uint86, uint87 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 3)
	elseif bytesAvailable == 4 then
		uint80, uint81, uint82, uint83 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 4)
		bufferOffset, bytesAvailable = self:NextBlock ()
		uint84, uint85, uint86, uint87 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 4)
	elseif bytesAvailable == 3 then
		uint80, uint81, uint82 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 3)
		bufferOffset, bytesAvailable = self:NextBlock ()
		uint83, uint84, uint85, uint86, uint87 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 5)
	elseif bytesAvailable == 2 then
		uint80, uint81 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 2)
		bufferOffset, bytesAvailable = self:NextBlock ()
		uint82, uint83, uint84, uint85, uint86, uint87 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 6)
	elseif bytesAvailable == 1 then
		uint80 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 1)
		bufferOffset, bytesAvailable = self:NextBlock ()
		uint81, uint82, uint83, uint84, uint85, uint86, uint87 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 7)
	elseif bytesAvailable == 0 then
		bufferOffset, bytesAvailable = self:NextBlock ()
		uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87 = string.byte (self.Buffer, bufferOffset + 1, bufferOffset + 8)
	end
	self.Position = self.Position + 8
	
	return uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87
end

-- Internal, do not call
function self:NextBlock ()
	self.BufferPosition = self.BufferSize * math.floor (self.Position / self.BufferSize)
	self.Buffer         = ""
	
	self.InputStream:SeekAbsolute (self.BufferPosition)
	self.Buffer = self.InputStream:Read (self.BufferSize)
	
	local bufferOffset   = self.Position - self.BufferPosition
	local bytesAvailable = #self.Buffer - bufferOffset
	return bufferOffset, bytesAvailable
end
