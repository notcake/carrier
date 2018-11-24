local self = {}
Glass.Animator = Class(self, Glass.IAnimator)

function self:ctor(t0, interpolator, duration, updater)
	self.StartTime = t0
	self.Duration  = duration
	
	self.Completed = false
	
	self.Interpolator = interpolator
end

-- IAnimation
function self:IsCompleted()
	return self.Completed
end

function self:Update(t)
	self.Updated:Dispatch(self:GetParameter(t))
	
	if t >= self.StartTime + self.Duration then
		self.Completed = true
	end
	
	return not self.Completed
end

-- IAnimator
function self:GetStartTime()
	return self.StartTime
end

function self:GetEndTime()
	return self.StartTime + self.Duration
end

function self:GetDuration()
	return self.Duration
end

function self:GetInterpolator()
	return self.Interpolator
end

function self:GetParameter(t)
	local t = (t - self.StartTime) / self.Duration
	t = math.max(0, math.min(1, t))
	return self.Interpolator(t)
end
