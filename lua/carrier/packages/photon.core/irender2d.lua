local self = {}
Core.IRender2d = Interface (self)

function self:ctor ()
end

function self:DrawLine (color, x1, y1, x2, y2)
	Error ("IRender2d:DrawLine : Not implemented.")
end

function self:DrawRectangle (color, x, y, w, h)
	Error ("IRender2d:DrawRectangle : Not implemented.")
end

function self:FillRectangle (color, x, y, w, h)
	Error ("IRender2d:FillRectangle : Not implemented.")
end
