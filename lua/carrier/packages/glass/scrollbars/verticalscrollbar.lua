local self = {}
Glass.VerticalScrollbar = Class (self, Scrollbar)

function self:ctor ()
	self.UpButton = Scrollbar.Button (Glass.Direction.Up)
	self.UpButton:SetParent (self)
	self.UpButtonBehaviour = Scrollbar.ButtonBehaviour (self, self.UpButton, -1)
	self.DownButton = Scrollbar.Button (Glass.Direction.Down)
	self.DownButton:SetParent (self)
	self.DownButtonBehaviour = Scrollbar.ButtonBehaviour (self, self.DownButton, 1)
	
	self.Grip = Scrollbar.Grip (Glass.Orientation.Horizontal)
	self.Grip:SetParent (self)
	
	self.GripDragY        = nil
	self.GripDragFraction = nil
	
	self.DragBehaviour = Glass.DragBehaviour (self.Grip)
	self.DragBehaviour.Started:AddListener (
		function ()
			self.GripDragY = select (2, self:GetMousePosition ())
			self.GripDragFraction = (self.GripDragY - select (2, self.Grip:GetPosition ())) / self:GetGripSize ()
		end
	)
	self.DragBehaviour.Updated:AddListener (
		function (dx, dy)
			local y = self.GripDragY + dy - self.GripDragFraction * self:GetGripSize () - self:GetWidth ()
			self:SetScrollPosition (self:GripPositionToScrollPosition (y))
		end
	)
	
	self.TrackAnimation = nil
	self.ButtonBehaviour = Glass.ButtonBehaviour (self)
end

function self:dtor ()
	self.UpButtonBehaviour  :dtor ()
	self.DownButtonBehaviour:dtor ()
end

-- IView
-- Content layout
function self:GetPreferredSize (maximumWidth, maximumHeight)
	return self:GetThickness (), maximumHeight or self:GetHeight ()
end

-- Internal
function self:OnLayout (w, h)
	self.UpButton:SetRectangle (0, 0, w, w)
	self.DownButton:SetRectangle (0, h - w, w, w)
	
	self.Grip:SetRectangle (0, w + self:ScrollPositionToGripPosition (self:GetAnimatedScrollPosition ()), w, self:GetGripSize ())
end

-- Scrollbar
function self:GetOrientation ()
	return Glass.Orientation.Vertical
end

function self:GetTrackSize ()
	return self:GetHeight () - self:GetWidth () * 2
end

-- Internal
function self:ScrollTrack (x, y)
	local scrollPosition = self:GripPositionToScrollPosition (y - self:GetWidth () - 0.5 * self.Grip:GetHeight ())
	if y < self.Grip:GetY () + 0.5 * self.Grip:GetHeight () then
		self:SetScrollPosition (math.max (scrollPosition, self:GetScrollPosition () - self:GetSmallIncrement ()))
	else
		self:SetScrollPosition (math.min (scrollPosition, self:GetScrollPosition () + self:GetSmallIncrement ()))
	end
end

-- VerticalScrollbar
function self:ScrollUp (animated)
	self:ScrollSmallIncrements (-1, animated)
end

function self:ScrollDown (animated)
	self:ScrollSmallIncrements (1, animated)
end
