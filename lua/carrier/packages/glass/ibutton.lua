local self = {}
Glass.IButton = Interface (self, Glass.IView)

function self:ctor ()
end

function self:IsHovered ()
	Error ("IButton:IsHovered : Not implemented.")
end

function self:IsPressed ()
	Error ("IButton:IsPressed : Not implemented.")
end
