local self = {}
Glass.RectangleAnimator = Class(self, Glass.IAnimation)

self.Updated = Event()

function self:ctor(x, y, w, h)
	self.Completed = false
	
	self.PositionAnimator = Glass.Vector2dAnimator(x, y)
	self.SizeAnimator     = Glass.Vector2dAnimator(w, h)
end

-- IAnimation
function self:IsCompleted()
	return self.Completed
end

function self:Update(t)
	if self.Completed then return end
	
	self.PositionAnimator:Update(t)
	self.SizeAnimator    :Update(t)
	
	self.Updated:Dispatch(self:GetRectangle(t))
	
	self.Completed = self.PositionAnimator:IsCompleted() and
	                 self.SizeAnimator:IsCompleted()
	
	return not self.Completed
end

-- RectangleAnimator
function self:GetRectangle(t)
	local x, y = self:GetPosition(t)
	local w, h = self:GetSize(t)
	return x, y, w, h
end

function self:GetPosition(t)
	return self.PositionAnimator:GetVector(t)
end

function self:GetSize(t)
	return self.SizeAnimator:GetVector(t)
end

function self:SetRectangle(t, x, y, w, h, animator)
	self:SetPosition(t, x, y, animator)
	self:SetSize    (t, w, h, animator)
end

function self:SetPosition(t, x, y, animator)
	self.PositionAnimator:SetVector(t, x, y, animator)
	if animator then self.Completed = false end
end

function self:SetX(t, x, animator)
	self.PositionAnimator:SetX(t, x, animator)
	if animator then self.Completed = false end
end

function self:SetY(t, y, animator)
	self.PositionAnimator:SetY(t, y, animator)
	if animator then self.Completed = false end
end

function self:SetSize(t, w, h, animator)
	self.SizeAnimator:SetVector(t, w, h, animator)
	if animator then self.Completed = false end
end

function self:SetWidth(t, w, animator)
	self.SizeAnimator:SetX(t, w, animator)
	if animator then self.Completed = false end
end

function self:SetHeight(t, h, animator)
	self.SizeAnimator:SetY(t, h, animator)
	if animator then self.Completed = false end
end
