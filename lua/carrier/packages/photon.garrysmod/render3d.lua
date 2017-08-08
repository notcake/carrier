local self = {}
Render3d = Class (self, Photon.IRender2d)

function self:ctor (graphicsContext)
	self.GraphicsContext = graphicsContext
end

function self:GetGraphicsContext ()
	return self.GraphicsContext
end
