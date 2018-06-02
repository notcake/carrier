local self = {}
Render3d = Class (self, Photon.IRender3d)

function self:ctor (graphicsContext)
	self.GraphicsContext = graphicsContext
	
	self.RenderTarget = nil
	self.RenderTargetStack = {}
end

-- IRender3d
function self:GetGraphicsContext ()
	return self.GraphicsContext
end

function self:PushRenderTarget (renderTarget)
	self.RenderTarget = renderTarget
	self.RenderTargetStack [#self.RenderTargetStack + 1] = renderTarget
	if #self.RenderTargetStack == 1 then
		render.OverrideAlphaWriteEnable (true, true)
		render.OverrideBlendFunc (true, BLEND_SRC_ALPHA, BLEND_ONE_MINUS_SRC_ALPHA, BLEND_ONE, BLEND_ONE)
		surface.DisableClipping (true)
	end
	
	render.PushRenderTarget (renderTarget:GetHandle ())
end

function self:PopRenderTarget ()
	render.PopRenderTarget ()
	
	self.RenderTargetStack [#self.RenderTargetStack] = nil
	self.RenderTarget = self.RenderTargetStack [#self.RenderTargetStack]
	
	if #self.RenderTargetStack == 0 then
		render.OverrideAlphaWriteEnable (false)
		render.OverrideBlendFunc (false)
		surface.DisableClipping (false)
	end
end

function self:WithRenderTarget (renderTarget, f)
	self:PushRenderTarget (renderTarget)
	local success, err = xpcall (f, debug.traceback)
	self:PopRenderTarget ()
	
	if not success then
		ErrorNoHalt (err)
	end
end

function self:ClearRenderTarget ()
	if self.RenderTarget:HasDepthStencilBuffer () then
		render.ClearDepth ()
	end
	
	render.Clear (0, 0, 0, 0)
end
