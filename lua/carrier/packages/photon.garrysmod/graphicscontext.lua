local self = {}
GraphicsContext = Class (self, Photon.IGraphicsContext)

function self:ctor ()
	local frameTexture = render.GetScreenEffectTexture ()
	self.FrameWidth  = frameTexture:Width ()
	self.FrameHeight = frameTexture:Height ()
	
	self.UsedRenderTargetHandles = {}
	self.FreeRenderTargetHandles = {}
	
	self.Render2d     = Render2d (self)
	self.Render3d     = Render3d (self)
	self.TextRenderer = TextRenderer ()
end

-- IGraphicsContext
function self:CreateMesh ()
	Error ("GraphicsContext:CreateMesh : Not implemented.")
end

function self:CreateRenderTarget (width, height, depthEnabled)
	return RenderTarget (self, width, height, depthEnabled)
end

function self:CreateFrameRenderTarget (dxOrDepthEnabled, dy, depthEnabled)
	local dx = depthEnabled ~= nil and dxOrDepthEnabled or 0
	local depthEnabled = depthEnabled == nil and dxOrDepthEnabled or depthEnabled
	
	local frameRenderTarget = FrameRenderTarget (self, self.FrameWidth, self.FrameHeight, name, dx, dy)
	self.FrameRenderTargets [frameRenderTarget] = true
	
	return frameRenderTarget
end

-- GraphicsContext
function self:GetRender2d ()
	return self.Render2d
end

function self:GetRender3d ()
	return self.Render3d
end

function self:GetTextRenderer ()
	return self.TextRenderer
end

function self:DestroyFrameRenderTarget (frameRenderTarget)
	self.FrameRenderTargets [frameRenderTarget] = nil
end

-- Internal
function self:AllocRenderTargetHandle (width, height, depthEnabled)
	local baseName = "Photon_GarrysMod_RenderTarget_" .. width .. "_" .. height .. "_" .. (depthEnabled and 1 or 0) .. "_"
	
	for i = 0, math.huge do
		local name = baseName .. i
		if self.UsedRenderTargetHandles [name] then
		elseif self.FreeRenderTargetHandles [name] then
			local handle = self.FreeRenderTargetHandles [name]
			self.FreeRenderTargetHandles [name] = nil
			return name, handle
		else
			self.UsedRenderTargetHandles [name] = true
			local handle = GetRenderTargetEx (name, width, height, RT_SIZE_NO_CHANGE, depthEnabled and MATERIAL_RT_DEPTH_SEPARATE or MATERIAL_RT_DEPTH_NONE, 0, 0, IMAGE_FORMAT_DEFAULT)
			return name, handle
		end
	end
end

function self:FreeRenderTargetHandle (name, handle)
	self.UsedRenderTargetHandles [name] = nil
	self.FreeRenderTargetHandles [name] = handle
end

function self:UpdateFrameRenderTargets ()
	local width, height = self.FrameWidth, self.FrameHeight
	for frameRenderTarget, _ in pairs (self.FrameRenderTargets) do
		self:FreeRenderTargetHandle (frameRenderTarget:GetName (), frameRenderTarget:GetHandle ())
		local dx, dy = frameRenderTarget:GetSizeAdjustment ()
		local name, handle = self:AllocRenderTargetHandle (width + dx, height + dy)
		frameRenderTarget:Update (name, handle, width + dx, height + dy)
	end
end
