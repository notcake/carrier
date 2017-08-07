local self = {}
Glass.InterpolatedAnimation = Class (self, Glass.IInterpolatedAnimation)

function self:ctor (t0, interpolator, duration, updater, ...)
	self.StartTime = t0
	
	self.Completed = false
	
	self.Interpolator = interpolator
	
	self.Duration = duration
	
	self.Updater = updater
	
	self.ArgumentCount, self.Arguments = CompactList.Pack (...)
end

-- IAnimation
function self:GetStartTime ()
	return self.StartTime
end

function self:IsCompleted ()
	return self.Completed
end

function self:Update (t)
	local x = (t - self.StartTime) / self.Duration
	x = math.max (0, math.min (1, x))
	local y = self.Interpolator (x)
	local uncompleted = self.Updater (y, CompactList.Unpack (self.ArgumentCount, self.Arguments))
	
	if uncompleted == false then
		self.Completed = true
	end
	
	if t >= self.StartTime + self.Duration then
		self.Completed = true
	end
	
	return not self.Completed
end

-- IInterpolatedAnimation
function self:GetDuration ()
	return self.Duration
end
