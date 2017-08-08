local self = {}
Glass.Vector2dAnimator = Class (self, Glass.AnimatorHost, Glass.IAnimation)

function self:ctor (x, y, updater)
	self.Completed = false
	
	self.InitialX = x
	self.InitialY = y
	self.FinalX   = x
	self.FinalY   = y
	
	self.XAnimation = nil
	self.YAnimation = nil
	
	self.Updater = updater
end

-- IAnimation
function self:GetStartTime ()
	return math.min (
		self.XAnimation and self.XAnimation:GetStartTime () or math.huge,
		self.YAnimation and self.YAnimation:GetStartTime () or math.huge
	)
end

function self:GetEndTime ()
	return math.max (
		self.XAnimation and self.XAnimation:GetEndTime () or -math.huge,
		self.YAnimation and self.YAnimation:GetEndTime () or -math.huge
	)
end

function self:GetDuration ()
	return self:GetEndTime () - self:GetStartTime ()
end

function self:GetInterpolator ()
	return Glass.Interpolators.Linear ()
end

function self:GetParameter (t)
	t = (t - self:GetStartTime ()) / self:GetDuration ()
	t = math.max (0, math.min (1, t))
	return t
end

function self:IsCompleted ()
	return self.Completed
end

function self:Update (t)
	if self.Completed then return end
	
	local x, y = self:GetVector (t)
	
	local completedX = not self.XAnimation and true or self.XAnimation:IsCompleted ()
	local completedY = not self.YAnimation and true or self.YAnimation:IsCompleted ()
	
	if completedX then self.XAnimation = nil end
	if completedY then self.YAnimation = nil end
	
	self.Completed = completedX and completedY
	
	if self.Updater then
		self.Updater (x, y)
	end
	
	return not self.Completed
end

-- RectangleAnimator
function self:GetVector (t)
	local x0, y0 = self.InitialX, self.InitialY
	local x1, y1 = self.FinalX,   self.FinalY
	
	local tx = self.XAnimation and self.XAnimation:GetParameter (t) or 1
	local ty = self.YAnimation and self.YAnimation:GetParameter (t) or 1
	
	return x0 + tx * (x1 - x0), y0 + ty * (y1 - y0)
end

function self:SetVector (t, x, y, animation)
	self.InitialX, self.InitialY = self:GetVector (t)
	self.FinalX,   self.FinalY   = x, y
	
	self.XAnimation = animation
	self.YAnimation = animation
	
	if animation then self.Completed = false end
end

function self:SetX (t, x, animation)
	local x0, _ = self:GetPosition (t)
	self.InitialX = x0
	self.FinalX   = x
	
	self.XAnimation = animation
	
	if animation then self.Completed = false end
end

function self:SetY (t, y, animation)
	local _, y0 = self:GetPosition (t)
	self.InitialY = y0
	self.FinalY   = y
	
	self.YAnimation = animation
	
	if animation then self.Completed = false end
end
