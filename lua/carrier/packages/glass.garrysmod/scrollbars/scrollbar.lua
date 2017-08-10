local self = {}
Scrollbar = Class (self, Glass.View)

self.Scroll         = Event ()
self.ScrollAnimated = Event ()

function self:ctor ()
	self.ContentSize    = 0
	self.ViewSize       = 1
	
	self.ScrollPosition = 0
	self.ScrollPositionAnimator = Glass.ValueAnimator (0)
	self.ScrollPositionAnimator.Updated:AddListener (
		function (scrollPosition)
			self.ScrollAnimated:Dispatch (scrollPosition)
			self:InvalidateLayout ()
		end
	)
	
	self.SmallIncrement = 64
	
	self.TrackAnimation = nil
	self.ButtonBehaviour = Glass.ButtonBehaviour (self)
	
	self:SetConsumesMouseEvents (true)
end

-- IView
-- Internal
function self:Render (w, h, render2d)
	render2d:FillRectangle (Color.FromRGBA8888 (240, 240, 240, 255), 0, 0, w, h)
end

function self:OnMouseDown (mouseButtons, x, y)
	if mouseButtons == Glass.MouseButtons.Left then
		self.TrackAnimation = self:CreateAnimation (
			function (t0, t)
				if not self.ButtonBehaviour:IsPressed () then return end
				self:ScrollTrack (self:GetMousePosition ())
			end
		)
	end
end

function self:OnMouseUp (mouseButtons, x, y)
	if mouseButtons == Glass.MouseButtons.Left then
		self:RemoveAnimation (self.TrackAnimation)
		self:ScrollTrack (x, y)
	end
end

-- Scrollbar
-- Metrics
function self:GetOrientation ()
	Error ("Scrollbar:GetOrientation : Not implemented.")
end

function self:GetThickness ()
	return self:GetSkin ():GetScrollbarThickness ()
end

function self:GetTrackSize ()
	Error ("Scrollbar:GetTrackSize : Not implemented.")
end

function self:GetGripSize ()
	local gripSize = self:GetTrackSize () * self:GetViewSize () / self:GetContentSize ()
	gripSize = math.floor (gripSize + 0.5)
	return math.min (self:GetTrackSize (), math.max (8, gripSize))
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

function self:GetAnimatedScrollPosition (t)
	local t = t or Clock ()
	return self.ScrollPositionAnimator:GetValue (t)
end

function self:GetSmallIncrement ()
	return self.SmallIncrement
end

function self:SetContentSize (contentSize)
	if self.ContentSize == contentSize then return end
	
	self.ContentSize = contentSize
	
	self:SetScrollPosition (self:GetScrollPosition ())
	self:InvalidateLayout ()
end

function self:SetViewSize (viewSize)
	if self.ViewSize == viewSize then return end
	
	self.ViewSize = viewSize
	
	self:SetScrollPosition (self:GetScrollPosition ())
	self:InvalidateLayout ()
end

function self:SetScrollPosition (scrollPosition, animated)
	local scrollPosition = math.max (0, math.min (self.ContentSize - self.ViewSize, scrollPosition))
	local animated = animated == nil and true or animated
		
	if self.ScrollPosition == scrollPosition then return end
	
	self.ScrollPosition = scrollPosition
	
	self.Scroll:Dispatch (self.ScrollPosition)
	if animated then
		-- Add animations to parent so that animations continue even if
		-- we're hidden
		self.ScrollPositionAnimator:SetValue (Clock (), self.ScrollPosition, self:GetParent ():CreateAnimator (Glass.Interpolators.ExponentialDecay (0.001), 0.25))
		self:GetParent ():AddAnimation (self.ScrollPositionAnimator)
	else
		self.ScrollAnimated:Dispatch (self.ScrollPosition)
		self.ScrollPositionAnimator:SetValue (Clock (), self.ScrollPosition)
	end
	
	self:InvalidateLayout ()
end

function self:SetSmallIncrement (smallIncrement)
	self.SmallIncrement = smallIncrement
end

function self:ScrollSmallIncrement (n, animated)
	self:SetScrollPosition (self:GetScrollPosition () + n * self:GetSmallIncrement (), animated)
end

-- Internal
function self:ScrollTrack (x, y)
	Error ("Scrollbar:ScrollTrack : Not implemented.")
end
