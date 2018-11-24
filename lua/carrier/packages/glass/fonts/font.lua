local self = {}
Glass.Font = Class(self, IFont)

function self:ctor(name, size, weight)
	local weight = weight or Glass.FontWeight.Regular
	
	self.Name   = name
	self.Size   = size
	self.Weight = weight
end

function self:GetName()
	return self.Name
end

function self:GetHeight()
	return self.Size
end

function self:GetSize()
	return self.Size
end

function self:GetWeight()
	return self.Weight
end

function self:WithSize(size)
	return Glass.Font(self:GetName(), size, self:GetWeight())
end

function self:WithWeight(weight)
	return Glass.Font(self:GetName(), self:GetSize(), weight)
end
