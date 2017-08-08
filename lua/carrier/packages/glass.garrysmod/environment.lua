local self = {}
GarrysMod.Environment = Class (self, Glass.IEnvironment)

function self:ctor ()
end

function self:GetGraphicsContext ()
	return Photon.GraphicsContext
end

function self:GetTextRenderer ()
	return Photon.TextRenderer
end

GarrysMod.Environment = GarrysMod.Environment ()
