local self = {}
Asn1.ObjectIdentifier = Class(self, IEnumerable)

function Asn1.ObjectIdentifier.FromString(s)
	local t = {}
	for n in string.gmatch(s, "[0-9]+") do
		t[#t + 1] = tonumber(n)
	end
	
	return Asn1.ObjectIdentifier(t)
end

function self:ctor(a, ...)
	if type(a) == "table" then
		for i = 1, #a do
			self[i] = a[i]
		end
	elseif type(a) == "number" then
		self[1] = a
		if ... then
			for _, v in ipairs({...}) do
				self[#self + 1] = v
			end
		end
	end
end

-- IEnumerable<number>
function self:GetEnumerator()
	return ArrayEnumerator(self)
end

function self:ToString()
	local t = {}
	for i = 1, #self do
		t[#t + 1] = tostring(self[i])
	end
	
	return table.concat(t, ".")
end

function self:__tostring()
	return self:ToString()
end

Asn1.ObjectIdentifier.rsaEncryption = Asn1.ObjectIdentifier.FromString("1.2.840.113549.1.1.1")
Asn1.ObjectIdentifier.sha256        = Asn1.ObjectIdentifier.FromString("2.16.840.1.101.3.4.2.1")
