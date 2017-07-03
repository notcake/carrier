local self = {}
Photon.IRender2d = Interface (self)

function self:ctor ()
end

function self:DrawRectangle (color, x, y, w, h)
	Error ("IRender2d:DrawRectangle : Not implemented.")
end

function self:FillRectangle (color, x, y, w, h)
	Error ("IRender2d:FillRectangle : Not implemented.")
end
