local self = {}
Glass.Vector2dAnimator = Class (self, Glass.IAnimation)

self.Updated = Event ()

function self:ctor (x, y)
	self.Completed = false
	
	self.InitialX = x
	self.InitialY = y
	self.FinalX   = x
	self.FinalY   = y
	
	self.XAnimator = nil
	self.YAnimator = nil
end

-- IAnimation
function self:IsCompleted ()
	return self.Completed
end

function self:Update (t)
	if self.Completed then return end
	
	local x, y = self:GetVector (t)
	
	local completedX = not self.XAnimator and true or self.XAnimator:IsCompleted ()
	local completedY = not self.YAnimator and true or self.YAnimator:IsCompleted ()
	
	if completedX then self.XAnimator = nil end
	if completedY then self.YAnimator = nil end
	
	self.Updated:Dispatch (x, y)
	
	self.Completed = completedX and completedY
	
	return not self.Completed
end

-- Vector2dAnimator
function self:GetVector (t)
	local x0, y0 = self.InitialX, self.InitialY
	local x1, y1 = self.FinalX,   self.FinalY
	
	local tx = self.XAnimator and self.XAnimator:GetParameter (t) or 1
	local ty = self.YAnimator and self.YAnimator:GetParameter (t) or 1
	
	return x0 + tx * (x1 - x0), y0 + ty * (y1 - y0)
end

function self:SetVector (t, x, y, animator)
	self.InitialX, self.InitialY = self:GetVector (t)
	self.FinalX,   self.FinalY   = x, y
	
	self.XAnimator = animator
	self.YAnimator = animator
	
	if animator then self.Completed = false end
end

function self:SetX (t, x, animator)
	local x0, _ = self:GetPosition (t)
	self.InitialX = x0
	self.FinalX   = x
	
	self.XAnimator = animator
	
	if animator then self.Completed = false end
end

function self:SetY (t, y, animator)
	local _, y0 = self:GetPosition (t)
	self.InitialY = y0
	self.FinalY   = y
	
	self.YAnimator = animator
	
	if animator then self.Completed = false end
end
