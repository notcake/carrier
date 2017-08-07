local self = {}
Glass.IAnimation = Interface (self)

function self:ctor ()
end

function self:GetStartTime ()
	Error ("IAnimation:GetStartTime : Not implemented.")
end

function self:IsCompleted ()
	Error ("IAnimation:IsCompleted : Not implemented.")
end

function self:Update (t)
	Error ("IAnimation:Update : Not implemented.")
end
