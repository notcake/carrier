local self = {}
FrameRenderTarget = Class (FrameRenderTarget, Texture, RenderTarget)

function self:ctor (graphicsContext, frameWidth, frameHeight, depthEnabled, dx, dy)
	self.GraphicsContext = graphicsContext
	
	self.Width  = frameWidth  + dx
	self.Height = frameHeight + dy
	
	self.DepthEnabled = depthEnabled
	
	self.WidthAdjustment  = dx
	self.HeightAdjustment = dy
	
	self.Name, self.Handle = self.GraphicsContext:AllocRenderTargetHandle (self.Width, self.Height, self.DepthEnabled)
end

function self:dtor ()
	self.GraphicsContext:FreeRenderTargetHandle (self.Name, self.Handle)
	self.GraphicsContext:DestroyFrameRenderTarget (self)
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

-- IRenderTarget
function self:HasDepthStencilBuffer ()
	return self.DepthEnabled
end

-- FrameRenderTarget
function self:GetSizeAdjustment ()
	return self.WidthAdjustment, self.HeightAdjustment
end

function self:GetWidthAdjustment ()
	return self.WidthAdjustment
end

function self:GetHeightAdjustment ()
	return self.HeightAdjustment
end

function self:Update (frameWidth, frameHeight)
	if self.Handle then
		self.GraphicsContext:FreeRenderTargetHandle (self.Name, self.Handle)
	end
	
	self.Width  = frameWidth  + self.WidthAdjustment
	self.Height = frameHeight + self.HeightAdjustment
	
	self.Name, self.Handle = self.GraphicsContext:AllocRenderTargetHandle (self.Width, self.Height, self.DepthEnabled)
end
