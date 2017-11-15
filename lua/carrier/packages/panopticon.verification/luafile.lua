local self = {}
Verification.LuaFile = Class (self, ISerializable)

function self:ctor (path, extended)
	self.Extended = extended or false
	
	self.Path = path
	self.CRC32 = 0
	self.LastModificationTime = 0
	self.Size = 0
	
	self.FunctionCount = 0
	
	self.StartLines = {}
	self.EndLines   = {}
	self.MD5s       = {}
	
	if self.Extended then
		self.CRC32s  = {}
		self.SHA256s = {}
	end
end

-- ISerializable
function self:Serialize (streamWriter)
	streamWriter:StringN16 (self.Path)
	streamWriter:UInt32 (self.CRC32)
	streamWriter:UInt32 (self.LastModificationTime)
	streamWriter:UInt32 (self.Size)
	streamWriter:UInt32 (self.FunctionCount)
	
	for i = 1, self.FunctionCount do
		streamWriter:UInt32 (self.StartLines [i])
		streamWriter:UInt32 (self.EndLines   [i])
		streamWriter:Bytes (self.MD5s [i])
		
		if self.Extended then
			streamWriter:UInt32 (self.CRC32s [i])
			streamWriter:Bytes (self.SHA256s [i])
		end
	end
end

function self:Deserialize (streamReader)
	self.Path                 = streamReader:StringN16 ()
	self.CRC32                = streamReader:UInt32 ()
	self.LastModificationTime = streamReader:UInt32 ()
	self.Size                 = streamReader:UInt32 ()
	self.FunctionCount        = streamReader:UInt32 ()
	
	for i = 1, self.FunctionCount do
		self.StartLines [i] = streamReader:UInt32 ()
		self.EndLines   [i] = streamReader:UInt32 ()
		self.MD5s       [i] = streamReader:Bytes (16)
		
		if self.Extended then
			self.CRC32s  [i] = streamReader:UInt32 ()
			self.SHA256s [i] = streamReader:Bytes (32)
		end
	end
end

-- LuaFile
function self:AddCode (code)
	local f, err = loadstring (code, self.Path)
	if not f then return false, err end
	
	self:AddDump (string.dump (f))
	
	return true
end

function self:AddDump (dump)
	local inputStream = IO.StringInputStream (dump)
	
	-- Header
	inputStream:Bytes (4) -- Signature
	inputStream:UInt8 ()  -- Flags
	
	inputStream:Bytes (ULEB128.Deserialize (inputStream)) -- Source
	
	-- Functions
	local functionDataLength = ULEB128.Deserialize (inputStream)
	while functionDataLength ~= 0 do
		local nextPosition = inputStream:GetPosition () + functionDataLength
		self:AddFunctionDump (inputStream)
		inputStream:SeekAbsolute (nextPosition)
		functionDataLength = ULEB128.Deserialize (inputStream)
	end
end

function self:AddFunctionDump (inputStream)
	inputStream:UInt8   () -- Flags
	inputStream:UInt8   () -- Fixed parameter count
	inputStream:UInt8   () -- Frame size
	inputStream:UInt8   () -- Upvalue count
	ULEB128.Deserialize (inputStream) -- Garbage collected constant count
	ULEB128.Deserialize (inputStream) -- Numeric constant count
	
	local instructionCount = ULEB128.Deserialize (inputStream) -- Instruction count
	
	ULEB128.Deserialize (inputStream) -- Debug data length
	
	local startLine = ULEB128.Deserialize (inputStream)
	local lineCount = ULEB128.Deserialize (inputStream)
	local normalizedBytecode = Verification.NormalizedBytecodeFromBytecodeDump (inputStream:Bytes (instructionCount * 4))
	
	self.FunctionCount = self.FunctionCount + 1
	self.StartLines [#self.StartLines + 1] = startLine
	self.EndLines   [#self.EndLines   + 1] = startLine + lineCount
	self.MD5s       [#self.MD5s       + 1] = String.FromHex (Crypto.MD5.Compute (normalizedBytecode))
	
	if self.Extended then
		self.CRC32s  [#self.CRC32s  + 1] = CRC32 (normalizedBytecode)
		self.SHA256s [#self.SHA256s + 1] = String.FromHex (Crypto.SHA256.Compute (normalizedBytecode))
	end
end

function self:GetPath ()
	return self.Path
end

function self:GetCRC32 ()
	return self.CRC32
end

function self:GetLastModificationTime ()
	return self.LastModificationTime
end

function self:GetSize ()
	return self.Size
end

function self:GetFunction (i)
	return self.StartLines [i], self.EndLines [i], self.MD5s [i], self.CRC32s [i], self.SHA256s [i]
end

function self:GetFunctionCount ()
	return self.FunctionCount
end
