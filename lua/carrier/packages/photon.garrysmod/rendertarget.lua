local self = {}
RenderTarget = Class(self, Photon.IRenderTarget)

function self:ctor(graphicsContext, width, height, depthEnabled)
	self.GraphicsContext = graphicsContext
	
	self.Width  = width
	self.Height = height
	
	self.DepthEnabled = depthEnabled
	
	self.Name, self.Handle = self.GraphicsContext:AllocRenderTargetHandle(self.Width, self.Height, self.DepthEnabled)
end

function self:dtor()
	self.GraphicsContext:FreeRenderTargetHandle(self.Name, self.Handle)
end

-- ITexture
function self:GetHandle()
	return self.Handle
end

function self:GetSize()
	return self.Width, self.Height
end

function self:GetWidth()
	return self.Width
end

function self:GetHeight()
	return self.Height
end

-- IRenderTarget
function self:HasDepthStencilBuffer()
	return self.DepthEnabled
end

-- RenderTarget
function self:GetName()
	return self.Name
end
