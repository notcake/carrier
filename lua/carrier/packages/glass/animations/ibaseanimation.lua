local self = {}
Glass.IBaseAnimation = Interface (self, Glass.IAnimatorHost)

function self:ctor ()
end

function self:IsCompleted ()
	Error ("IBaseAnimation:IsCompleted : Not implemented.")
end

function self:Update (t)
	Error ("IBaseAnimation:Update : Not implemented.")
end
