local self = {}
Glass.ValueAnimator = Class (self, Glass.IAnimation)

self.Updated = Event ()

function self:ctor (value, updater)
	self.Completed = false
	
	self.InitialValue = value
	self.FinalValue   = value
	
	self.Animator = nil
end

-- IAnimation
function self:IsCompleted ()
	return self.Completed
end

function self:Update (t)
	if self.Completed then return end
	
	local value = self:GetValue (t)
	
	local completed = not self.Animator and true or self.Animator:IsCompleted ()
	
	if completed then self.Animator = nil end
	
	self.Updated:Dispatch (value)
	
	self.Completed = completed
	
	return not self.Completed
end

-- ValueAnimator
function self:GetValue (t)
	local x0 = self.InitialValue
	local x1 = self.FinalValue
	
	local t = self.Animator and self.Animator:GetParameter (t) or 1
	
	return x0 + tx * (x1 - x0)
end

function self:SetValue (t, value, animator)
	self.InitialValue = self:GetValue (t)
	self.FinalValue   = value
	
	self.Animator = animator
	
	if animator then self.Completed = false end
end
