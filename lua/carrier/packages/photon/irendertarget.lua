local self = {}
Photon.IRenderTarget = Interface (self, Photon.ITexture)

function self:ctor ()
end

function self:HasDepthStencilBuffer ()
	Error ("IRenderTarget:HasDepthStencilBuffer : Not implemented.")
end
