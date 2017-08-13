local self = {}
Photon.IRender3d = Interface (self)

function self:ctor ()
end

function self:GetGraphicsContext ()
	Error ("IRender3d:GetGraphicsContext : Not implemented.")
end

function self:PushRenderTarget (renderTarget)
	Error ("IRender3d:PushRenderTarget : Not implemented.")
end

function self:PopRenderTarget ()
	Error ("IRender3d:PopRenderTarget : Not implemented.")
end

function self:WithRenderTarget (renderTarget, f)
	Error ("IRender3d:WithRenderTarget : Not implemented.")
end

function self:ClearRenderTarget ()
	Error ("IRender3d:ClearRenderTarget : Not implemented.")
end
