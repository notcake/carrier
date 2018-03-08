local typeDeserializers = {}

local function DeserializeIdentifier (streamReader)
	local c = streamReader:Bytes (1)
	if bit.band (string.byte (c), 31) == 31 then
		local s = c
		repeat
			c = streamReader:Bytes (1)
			s = s .. c
		until string.byte (c) < 0x80
	else
		return c
	end
end

local function DeserializeUInt (streamReader)
	local n = 0
	while true do
		local uint8 = streamReader:UInt8 ()
		
		n = n * 0x80
		if uint8 >= 0x80 then
			n = n + uint8 - 0x80
		else
			return n + uint8
		end
	end
end

local function DeserializeUIntN8 (streamReader)
	local uint8 = streamReader:UInt8 ()
	if uint8 >= 0x80 then
		local length = uint8 - 0x80
		local n = 0
		for i = 1, length do
			n = n * 0x0100
			n = n + streamReader:UInt8 ()
		end
		return n
	else
		return uint8
	end
end

local function DeserializeLength (streamReader)
	return DeserializeUIntN8 (streamReader)
end

local function DeserializeObject (streamReader)
	local identifier = DeserializeIdentifier (streamReader)
	local length     = DeserializeLength     (streamReader)
	local deserializer = typeDeserializers [identifier]
	if not deserializer then assert (false, "No deserializer found for " .. String.ToHex (identifier)) end
	
	local position = streamReader:GetPosition ()
	local object = deserializer (streamReader, length)
	
	if streamReader:GetPosition () ~= position + length then
		streamReader:SeekAbsolute (position + length)
	end
	
	return object
end

typeDeserializers ["\x01"] = function (streamReader, length)
	return streamReader:UInt8 () > 0
end

typeDeserializers ["\x02"] = function (streamReader, length)
	local blob = streamReader:Bytes (length)
	local n = BigInteger.FromBlob (blob)
	
	-- Negative
	if string.byte (blob, 1) >= 0x80 then
		local one = BigInteger.FromDouble (1)
		n = n:Subtract (one:ShiftLeft (#blob * 8, one), n)
	end
	
	return n
end

typeDeserializers ["\x03"] = function (streamReader, length)
	local uint8 = streamReader:UInt8 ()
	return streamReader:Bytes (length - 1)
end

typeDeserializers ["\x04"] = function (streamReader, length)
	return streamReader:Bytes (length)
end

typeDeserializers ["\x05"] = function (streamReader, length)
	streamReader:SeekRelative (length)
	return Asn1.Null
end

typeDeserializers ["\x06"] = function (streamReader, length)
	local position = streamReader:GetPosition ()
	
	local objectIdentifier = {}
	local uint = DeserializeUInt (streamReader)
	if uint < 40 then
		objectIdentifier [#objectIdentifier + 1] = 0
		objectIdentifier [#objectIdentifier + 1] = uint
	elseif uint < 80 then
		objectIdentifier [#objectIdentifier + 1] = 1
		objectIdentifier [#objectIdentifier + 1] = uint - 40
	else
		objectIdentifier [#objectIdentifier + 1] = 2
		objectIdentifier [#objectIdentifier + 1] = uint - 80
	end
	
	while streamReader:GetPosition () < position + length do
		objectIdentifier [#objectIdentifier + 1] = DeserializeUInt (streamReader)
	end
	
	return Asn1.ObjectIdentifier (objectIdentifier)
end

typeDeserializers ["\x30"] = function (streamReader, length)
	local position = streamReader:GetPosition ()
	
	local sequence = {}
	while streamReader:GetPosition () < position + length do
		sequence [#sequence + 1] = DeserializeObject (streamReader)
	end
	
	return sequence
end

function Asn1.Deserialize (input)
	local inputStream = StringInputStream (input)
	
	return DeserializeObject (inputStream)
end
