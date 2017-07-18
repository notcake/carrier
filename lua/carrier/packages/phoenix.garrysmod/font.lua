local self = {}
GarrysMod.Font = Class (self, IFont)

function GarrysMod.Font.Create (name, size, weight)
	local weight = weight or FontWeight.Normal
	
	local id = "Phoenix.GarrysMod.Font_" .. name .. "_" .. size .. "_" .. weight
	
	surface.CreateFont (id,
		{
			font   = name,
			size   = size,
			weight = weight
		}
	)
	
	return GarrysMod.Font (id, name, size, weight)
end

function self:ctor (id, name, size, weight)
	self.Id     = id
	self.Name   = name
	self.Size   = size
	self.Weight = weight
end

function self:GetId ()
	return self.Id
end

function self:GetName ()
	return self.Name
end

function self:GetHeight ()
	return self.Size
end

function self:GetSize ()
	return self.Size
end

function self:GetWeight ()
	return self.Weight
end

if system.IsLinux () then
	GarrysMod.Font.Default     = GarrysMod.Font ("DermaDefault",     "DejaVu Sans", 14, FontWeight.Medium)
	GarrysMod.Font.DefaultBold = GarrysMod.Font ("DermaDefaultBold", "DejaVu Sans", 14, FontWeight.Heavy)
else
	GarrysMod.Font.Default     = GarrysMod.Font ("DermaDefault",     "Tahoma", 13, FontWeight.Medium)
	GarrysMod.Font.DefaultBold = GarrysMod.Font ("DermaDefaultBold", "Tahoma", 13, FontWeight.Heavy)
end

GarrysMod.Font.Title = GarrysMod.Font ("DermaLarge", "Roboto", 32, FontWeight.Medium)
