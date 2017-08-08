local self = {}
Glass.IAnimation = Interface (self)

function self:ctor ()
end

function self:GetStartTime ()
	Error ("IAnimation:GetStartTime : Not implemented.")
end

function self:GetEndTime ()
	Error ("IAnimation:GetEndTime : Not implemented.")
end

function self:GetDuration ()
	Error ("IAnimation:GetDuration : Not implemented.")
end

function self:GetInterpolator ()
	Error ("IAnimation:GetInterpolator : Not implemented.")
end

function self:GetParameter (t)
	Error ("IAnimation:GetParameter : Not implemented.")
end

function self:IsCompleted ()
	Error ("IAnimation:IsCompleted : Not implemented.")
end

function self:Update (t)
	Error ("IAnimation:Update : Not implemented.")
end

function self:AttachAnimator (name, animator)
	Error ("IAnimation:Update : Not implemented.")
end

function self:DetachAnimator (name)
	Error ("IAnimation:Update : Not implemented.")
end
