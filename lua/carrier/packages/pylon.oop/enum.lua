local self = {}
OOP.Enum = OOP.Class (self)

function self:ctor (enum)
	if not next (enum) then
		Error ("Pylon.OOP.Enum : This enum appears to be empty!")
	end
	
	self.Names = {}
	
	for key, value in pairs (enum) do
		self [key] = value
		self.Names [value] = key
	end
end

function self:ToString (value)
	return self.Names [value] or string.format ("0x%08x", value)
end
