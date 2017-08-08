local self = {}
Glass.RectangleAnimator = Class (self, Glass.IBaseIAnimation)

function self:ctor (x, y, w, h, updater)
	self.Completed = false
	
	self.PositionAnimator = Glass.Vector2dAnimator (x, y)
	self.SizeAnimator     = Glass.Vector2dAnimator (w, h)
	
	self.Updater = updater
end

-- IBaseAnimation
function self:IsCompleted ()
	return self.Completed
end

function self:Update (t)
	if self.Completed then return end
	
	self.PositionAnimator:Update (t)
	self.SizeAnimator    :Update (t)
	
	if self.Updater then
		self.Updater (self:GetRectangle (t))
	end
	
	self.Completed = self.PositionAnimator:IsCompleted () and
	                 self.SizeAnimator:IsCompleted ()
	
	return not self.Completed
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
