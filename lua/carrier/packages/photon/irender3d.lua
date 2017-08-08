local self = {}
Photon.IRender3d = Interface (self)

function self:ctor ()
end

function self:GetGraphicsContext ()
	Error ("IRender3d:GetGraphicsContext : Not implemented.")
end
