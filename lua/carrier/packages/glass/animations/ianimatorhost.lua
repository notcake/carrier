local self = {}
Glass.IAnimatorHost = Interface (self)

function self:ctor ()
end

function self:AttachAnimator (name, animator)
	Error ("IAnimatorHost:Update : Not implemented.")
end

function self:DetachAnimator (name)
	Error ("IAnimatorHost:Update : Not implemented.")
end

function self:GetAnimatorEnumerator ()
	Error ("IAnimatorHost:GetAnimatorEnumerator : Not implemented.")
end
