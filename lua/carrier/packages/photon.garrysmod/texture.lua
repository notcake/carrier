local self = {}
Texture = Class (self, Photon.ITexture)

function self:ctor (graphicsContext, handle, width, height)
	self.GraphicsContext = graphicsContext
	
	self.Handle = handle
	
	self.Width  = width
	self.Height = height
end

-- ITexture
function self:GetHandle ()
	return self.Handle
end

function self:GetSize ()
	return self.Width, self.Height
end

function self:GetWidth ()
	return self.Width
end

function self:GetHeight ()
	return self.Height
end

-- Texture
function self:GetGraphicsContext ()
	return self.GraphicsContext
end

function self:Update (handle, width, height)
	self.Handle = handle
	
	self.Width  = width
	self.Height = height
end
