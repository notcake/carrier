local self = {}
Glass.IAnimator = Interface (self, Glass.IAnimation)

self.Updated = Event ()

function self:ctor ()
end

function self:GetStartTime ()
	Error ("IAnimator:GetStartTime : Not implemented.")
end

function self:GetEndTime ()
	Error ("IAnimator:GetEndTime : Not implemented.")
end

function self:GetDuration ()
	Error ("IAnimator:GetDuration : Not implemented.")
end

function self:GetInterpolator ()
	Error ("IAnimator:GetInterpolator : Not implemented.")
end

function self:GetParameter (t)
	Error ("IAnimator:GetParameter : Not implemented.")
end

function self:IsCompleted ()
	Error ("IAnimator:IsCompleted : Not implemented.")
end
