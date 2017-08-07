local self = {}
Glass.IInterpolatedAnimation = Interface (self, Glass.IAnimation)

function self:ctor ()
end

function self:GetDuration ()
	Error ("IInterpolatedAnimation:GetDuration : Not implemented.")
end

function self:GetInterpolator ()
	Error ("IInterpolatedAnimation:GetInterpolator : Not implemented.")
end
