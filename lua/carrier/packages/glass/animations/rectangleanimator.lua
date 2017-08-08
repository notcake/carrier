local self = {}
Glass.RectangleAnimator = Class (self, Glass.IAnimation)

function self:ctor (updater, x, y, w, h)
	self.Completed = false
	
	self.InitialX      = x
	self.InitialY      = y
	self.InitialWidth  = w
	self.InitialHeight = h
	self.FinalX      = x
	self.FinalY      = y
	self.FinalWidth  = w
	self.FinalHeight = h
	
	self.XAnimation      = nil
	self.YAnimation      = nil
	self.WidthAnimation  = nil
	self.HeightAnimation = nil
	
	self.Updater = updater
	
	self.Animators = {}
end

-- IAnimation
function self:GetStartTime ()
	local startTime = math.min (
		self.XAnimation      and self.XAnimation     :GetStartTime () or math.huge,
		self.YAnimation      and self.YAnimation     :GetStartTime () or math.huge,
		self.WidthAnimation  and self.WidthAnimation :GetStartTime () or math.huge,
		self.HeightAnimation and self.HeightAnimation:GetStartTime () or math.huge
	)
	
	return startTime == math.huge and 0 or startTime
end

function self:GetEndTime ()
	local endTime = math.max (
		self.XAnimation      and self.XAnimation     :GetEndTime () or -math.huge,
		self.YAnimation      and self.YAnimation     :GetEndTime () or -math.huge,
		self.WidthAnimation  and self.WidthAnimation :GetEndTime () or -math.huge,
		self.HeightAnimation and self.HeightAnimation:GetEndTime () or -math.huge
	)
	
	return endTime == -math.huge and 0 or endTime
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
	
	local x, y, w, h = self:GetRectangle (t)
	
	local completedX      = not self.XAnimation      and true or self.XAnimation     :IsCompleted ()
	local completedY      = not self.YAnimation      and true or self.YAnimation     :IsCompleted ()
	local completedWidth  = not self.WidthAnimation  and true or self.WidthAnimation :IsCompleted ()
	local completedHeight = not self.HeightAnimation and true or self.HeightAnimation:IsCompleted ()
	
	if completedX      then self.XAnimation      = nil end
	if completedY      then self.YAnimation      = nil end
	if completedWidth  then self.WidthAnimation  = nil end
	if completedHeight then self.HeightAnimation = nil end
	
	self.Completed = completedX and completedY and completedWidth and completedHeight
	
	self.Updater (x, y, w, h)
	
	return not self.Completed
end

-- RectangleAnimator
function self:GetPosition (t)
	local x0, y0 = self.InitialX, self.InitialY
	local x1, y1 = self.FinalX,   self.FinalY
	
	local tx = self.XAnimation and self.XAnimation:GetParameter (t) or 1
	local ty = self.YAnimation and self.YAnimation:GetParameter (t) or 1
	
	return x0 + tx * (x1 - x0), y0 + ty * (y1 - y0)
end

function self:GetSize (t)
	local w0, h0 = self.InitialWidth, self.InitialHeight
	local w1, h1 = self.FinalWidth,   self.FinalHeight
	
	local tw = self.WidthAnimation  and self.WidthAnimation :GetParameter (t) or 1
	local th = self.HeightAnimation and self.HeightAnimation:GetParameter (t) or 1
	
	return w0 + tw * (w1 - w0), h0 + th * (h1 - h0)
end

function self:GetRectangle (t)
	local x, y = self:GetPosition (t)
	local w, h = self:GetSize (t)
	return x, y, w, h
end

function self:SetRectangle (t, x, y, w, h, animation)
	self:SetPosition (t, x, y, animation)
	self:SetSize     (t, w, h, animation)
end

function self:SetPosition (t, x, y, animation)
	self.InitialX, self.InitialY = self:GetPosition (t)
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

function self:SetSize (t, w, h, animation)
	self.InitialWidth, self.InitialHeight = self:GetSize (t)
	self.FinalWidth,   self.FinalHeight   = w, h
	
	self.WidthAnimation  = animation
	self.HeightAnimation = animation
	
	if animation then self.Completed = false end
end

function self:SetWidth (t, w, animation)
	local w0, _ = self:GetSize (t)
	self.InitialWidth = w0
	self.FinalWidth   = w
	
	self.WidthAnimation = animation
	
	if animation then self.Completed = false end
end

function self:SetHeight (t, h, animation)
	local _, h0 = self:GetSize (t)
	self.InitialHeight = h0
	self.FinalHeight   = h
	
	self.HeightAnimation = animation
	
	if animation then self.Completed = false end
end
