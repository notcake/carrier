local typeSerializers = {}

local function SerializeIdentifier(streamWriter, identifier)
	streamWriter:Bytes(identifier)
end

local function SerializeUInt(streamWriter, uint32)
	local n = math.ceil(math.log(uint32 + 1, 0x80))
	local k = 1
	for i = 1, n - 1 do k = k * 0x80 end
	for i = n - 1, 1, -1 do
		streamWriter:UInt8(0x80 + math.floor((uint32 / k) % 0x80))
		k = k / 0x80
	end
	streamWriter:UInt8(math.floor((uint32 / k) % 0x80))
end

local function SerializeUIntN8(streamWriter, uint32)
	if uint32 < 0x80 then
		streamWriter:UInt8(uint32)
	else
		local n = math.ceil(math.log(uint32 + 1, 0x0100))
		local k = 1
		for i = 1, n - 1 do k = k * 0x0100 end
		for i = n - 1, 0, -1 do
			streamWriter:UInt8(math.floor((uint32 / k) % 0x0100))
			k = k / 0x0100
		end
	end
end

local function SerializeLength(streamWriter, length)
	SerializeUIntN8(streamWriter, length)
end

local function SerializeObject(streamWriter, object)
	local type = type(object)
	if type == "nil" then
		streamWriter:Bytes("\x05\x00")
	elseif type == "boolean" then
		streamWriter:Bytes(object and "\x01\x01\xFF" or "\x01\x01\x00")
	elseif type == "number" then
		if math.floor(object) == object then
			SerializeObject(streamWriter, BigInteger.FromDouble(object))
		else
			assert(false, "No serializer found for number")
		end
	elseif type == "string" then
		SerializeIdentifier(streamWriter, "\x04")
		SerializeLength(streamWriter, #object)
		streamWriter:Bytes(object)
	elseif type == "table" then
		if Asn1.Null == object then
			streamWriter:Bytes("\x05\x00")
		elseif BigInteger:IsInstance(object) then
			local blob = object:ToBlob()
			local signNeeded = object:IsNegative() ~= (string.byte(blob, 1) >= 0x80)
			
			SerializeIdentifier(streamWriter, "\x02")
			SerializeLength(streamWriter, #blob + (signNeeded and 1 or 0))
			if signNeeded then
				streamWriter:Bytes(object:IsNegative() and "\xFF" or "\x00")
			end
			streamWriter:Bytes(blob)
		elseif Asn1.ObjectIdentifier:IsInstance(object) then
			SerializeIdentifier(streamWriter, "\x06")
			local subStreamWriter = StringOutputStream()
			SerializeUInt(subStreamWriter, object[1] * 40 + object[2])
			for i = 3, #object do
				SerializeUInt(subStreamWriter, object[i])
			end
			SerializeLength(streamWriter, subStreamWriter:GetSize())
			streamWriter:Bytes(subStreamWriter:ToString())
		else
			SerializeIdentifier(streamWriter, "\x30")
			local subStreamWriter = StringOutputStream()
			for _, v in ipairs(object) do
				SerializeObject(subStreamWriter, v)
			end
			SerializeLength(streamWriter, subStreamWriter:GetSize())
			streamWriter:Bytes(subStreamWriter:ToString())
		end
	else
		assert(false, "No serializer found for " .. type)
	end
end

function Asn1.Serialize(object)
	local outputStream = StringOutputStream()
	
	SerializeObject(outputStream, object)
	
	return outputStream:ToString()
end
