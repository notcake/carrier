local self = {}
Glass.ValueAnimator = Class (self, Glass.IBaseAnimation)

function self:ctor (value, updater)
	self.Completed = false
	
	self.InitialValue = value
	self.FinalValue   = value
	
	self.Animation = nil
	
	self.Updater = updater
end

-- IBaseAnimation
function self:IsCompleted ()
	return self.Completed
end

function self:Update (t)
	if self.Completed then return end
	
	local value = self:GetValue (t)
	
	local completed = not self.Animation and true or self.Animation:IsCompleted ()
	
	if completed then self.Animation = nil end
	
	self.Completed = completed
	
	if self.Updater then
		self.Updater (value)
	end
	
	return not self.Completed
end

-- ValueAnimator
function self:GetValue (t)
	local x0 = self.InitialValue
	local x1 = self.FinalValue
	
	local t = self.Animation and self.Animation:GetParameter (t) or 1
	
	return x0 + tx * (x1 - x0)
end

function self:SetValue (t, value, animation)
	self.InitialValue = self:GetValue (t)
	self.FinalValue   = value
	
	self.Animation = animation
	
	if animation then self.Completed = false end
end
