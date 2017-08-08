local self = {}
Scrollbar = Class (self, GarrysMod.View)

self.Scroll         = Event ()
self.ScrollAnimated = Event ()

function self:ctor ()
	self.ContentSize    = 0
	self.ViewSize       = 1
	
	self.ScrollPosition = 0
	
	self.SmallIncrement = 32
	
	self:SetConsumesMouseEvents (true)
end

-- IView
-- Internal
function self:Render (w, h, render2d)
	render2d:FillRectangle (Color.FromRGBA8888 (240, 240, 240, 255), 0, 0, w, h)
end

-- Scrollbar
-- Metrics
function self:GetOrientation ()
	Error ("Scrollbar:GetOrientation : Not implemented.")
end

function self:GetThickness ()
	return GarrysMod.Skin.Default.Metrics.ScrollbarThickness
end

function self:GetTrackSize ()
	Error ("Scrollbar:GetTrackSize : Not implemented.")
end

function self:GetGripSize ()
	return self:GetTrackSize () * self:GetViewSize () / self:GetContentSize ()
end

function self:GripPositionToScrollPosition (gripPosition)
	local t = math.max (0, math.min (1, gripPosition / (self:GetTrackSize () - self:GetGripSize ())))
	return (self:GetContentSize () - self:GetViewSize ()) * t
end

function self:ScrollPositionToGripPosition (scrollPosition)
	local t = math.max (0, math.min (1, scrollPosition / (self:GetContentSize () - self:GetViewSize ())))
	return (self:GetTrackSize () - self:GetGripSize ()) * t
end

-- Content
function self:GetContentSize ()
	return self.ContentSize
end

function self:GetViewSize ()
	return self.ViewSize
end

function self:GetScrollPosition ()
	return self.ScrollPosition
end

function self:GetSmallIncrement ()
	return self.SmallIncrement
end

function self:SetContentSize (contentSize)
	if self.ContentSize == contentSize then return end
	
	self.ContentSize = contentSize
	
	self:InvalidateLayout ()
end

function self:SetViewSize (viewSize)
	if self.ViewSize == viewSize then return end
	
	self.ViewSize = viewSize
	
	self:InvalidateLayout ()
end

function self:SetScrollPosition (scrollPosition, animated)
	local scrollPosition = math.max (0, math.min (self.ContentSize - self.ViewSize, scrollPosition))
	local animated = animated == nil and true or animated
		
	if self.ScrollPosition == scrollPosition then return end
	
	self.ScrollPosition = scrollPosition
	
	self.Scroll:Dispatch (self.ScrollPosition)
	if animated then
	else
		self.ScrollAnimated:Dispatch (self.ScrollPosition)
	end
	
	self:InvalidateLayout ()
end

function self:SetSmallIncrement (smallIncrement)
	self.SmallIncrement = smallIncrement
end

function self:ScrollSmallIncrements (n, animated)
	self:SetScrollPosition (self:GetScrollPosition () + n * self:GetSmallIncrement (), animated)
end
