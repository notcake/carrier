local self = {}
OOP.Flags = OOP.Class (self, OOP.Enum)

function self:ctor (enum)
end

function self:HasFlag (flags, flag)
	return bit.band (flags, flag) == flag
end

function self:ToString (value)
	local testValue = 0
	
	local string = ""
	for v, k in pairs (self.Names) do
		if value == v then return k end
		
		if bit.band (value, v) == v then
			testValue = bit.bor (testValue, v)
			
			if string ~= "" then
				string = string .. " | "
			end
			string = string .. k
		end
	end
	
	-- Remainder
	local remainder = bit.band (value, bit.bnot (testValue))
	if remainder ~= 0 then
		if string ~= "" then
			string = string .. " | "
		end
		string = string .. string.format ("0x%08x", remainder)
	end
	
	if string == "" then return "0" end
	return string
end
