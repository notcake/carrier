local self = {}
Glass.Animation = Class (self, Glass.AnimatorHost, Glass.IAnimation)

function self:ctor (t0, interpolator, duration, updater)
	self.StartTime = t0
	self.Duration  = duration
	
	self.Completed = false
	
	self.Interpolator = interpolator
	
	self.Updater = updater
end

-- IAnimation
function self:GetStartTime ()
	return self.StartTime
end

function self:GetEndTime ()
	return self.StartTime + self.Duration
end

function self:GetDuration ()
	return self.Duration
end

function self:GetInterpolator ()
	return self.Interpolator
end

function self:GetParameter (t)
	local t = (t - self.StartTime) / self.Duration
	t = math.max (0, math.min (1, t))
	return self.Interpolator (t)
end

function self:IsCompleted ()
	return self.Completed
end

function self:Update (t)
	local y = self:GetParameter (t)
	
	local uncompleted = nil
	if self.Updater then
		uncompleted = self.Updater (y)
	end
	
	self:UpdateAnimators (y)
	
	if uncompleted == false then
		self.Completed = true
	end
	
	if t >= self.StartTime + self.Duration then
		self.Completed = true
	end
	
	return not self.Completed
end

function self:AttachAnimator (name, animator)
	local animator = animator or name
	
	self.Animators = self.Animators or {}
	self.Animators [name] = animator
end

function self:DetachAnimator (name)
	if not self.Animators then return end
	
	self.Animators [name] = nil
end
