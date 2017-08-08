local self = {}
Glass.RectangleAnimator = Class (self, Glass.AnimatorHost, Glass.IAnimation)

function self:ctor (x, y, w, h, updater)
	self.PositionAnimator = Glass.Vector2dAnimator (x, y)
	self.SizeAnimator     = Glass.Vector2dAnimator (w, h)
	
	self.Updater = updater
end

-- IAnimation
function self:GetStartTime ()
	return math.min (self.PositionAnimator:GetStartTime (), self.SizeAnimator:GetStartTime ())
end

function self:GetEndTime ()
	return math.max (self.PositionAnimator:GetEndTime (), self.SizeAnimator:GetEndTime ())
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
	return self.PositionAnimator:IsCompleted () and
	       self.SizeAnimator:IsCompleted ()
end

function self:Update (t)
	if self.Completed then return end
	
	self.PositionAnimator:Update (t)
	self.SizeAnimator    :Update (t)
	
	if self.Updater then
		self.Updater (self:GetRectangle (t))
	end
	
	return not self:IsCompleted ()
end

-- RectangleAnimator
function self:GetRectangle (t)
	local x, y = self:GetPosition (t)
	local w, h = self:GetSize (t)
	return x, y, w, h
end

function self:GetPosition (t)
	return self.PositionAnimator:GetVector (t)
end

function self:GetSize (t)
	return self.SizeAnimator:GetVector (t)
end

function self:SetRectangle (t, x, y, w, h, animation)
	self:SetPosition (t, x, y, animation)
	self:SetSize     (t, w, h, animation)
end

function self:SetPosition (t, x, y, animation)
	self.PositionAnimator:SetVector (t, x, y, animation)
end

function self:SetX (t, x, animation)
	self.PositionAnimator:SetX (t, x, animation)
end

function self:SetY (t, y, animation)
	self.PositionAnimator:SetY (t, y, animation)
end

function self:SetSize (t, w, h, animation)
	self.SizeAnimator:SetVector (t, w, h, animation)
end

function self:SetWidth (t, w, animation)
	self.SizeAnimator:SetX (t, w, animation)
end

function self:SetHeight (t, h, animation)
	self.SizeAnimator:SetY (t, h, animation)
end
