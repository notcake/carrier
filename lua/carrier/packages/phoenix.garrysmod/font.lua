local self = {}
GarrysMod.Font = Class (self, IFont)

function GarrysMod.Font.Create (name, size, weight)
	local weight = weight or FontWeight.Regular
	
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

function self:WithSize (size)
	return GarrysMod.Font.Create (self:GetName (), size, self:GetWeight ())
end

function self:WithWeight (weight)
	return GarrysMod.Font.Create (self:GetName (), self:GetSize (), weight)
end
