local self = {}
Glass.IAnimation = Interface (self, Glass.IAnimatorHost)

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
