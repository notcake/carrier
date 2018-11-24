local self = {}
Photon.IGraphicsContext = Interface(self)

function self:ctor()
end

function self:CreateMesh()
	Error("IGraphicsContext:CreateMesh : Not implemented.")
end

function self:CreateRenderTarget(width, height, depthEnabled)
	Error("IGraphicsContext:CreateRenderTarget : Not implemented.")
end

function self:CreateFrameRenderTarget(dxOrDepthEnabled, dy, depthEnabled)
	Error("IGraphicsContext:CreateFrameRenderTarget : Not implemented.")
end
