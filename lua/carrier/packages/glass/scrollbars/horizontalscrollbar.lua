local self = {}
Glass.HorizontalScrollbar = Class (self, Scrollbar)

function self:ctor ()
	self.LeftButton = Scrollbar.Button (Glass.Direction.Left)
	self.LeftButton:SetParent (self)
	self.LeftButtonBehaviour = Scrollbar.ButtonBehaviour (self, self.LeftButton, -1)
	self.RightButton = Scrollbar.Button (Glass.Direction.Right)
	self.RightButton:SetParent (self)
	self.RightButtonBehaviour = Scrollbar.ButtonBehaviour (self, self.RightButton, 1)
	
	self.Grip = Scrollbar.Grip (Glass.Orientation.Horizontal)
	self.Grip:SetParent (self)
	
	self.GripDragX        = nil
	self.GripDragFraction = nil
	
	self.DragBehaviour = Glass.DragBehaviour (self.Grip)
	self.DragBehaviour.Started:AddListener (
		function ()
			self.GripDragX = self:GetMousePosition ()
			self.GripDragFraction = (self.GripDragX - self.Grip:GetPosition ()) / self:GetGripSize ()
		end
	)
	self.DragBehaviour.Updated:AddListener (
		function (dx, dy)
			local x = self.GripDragX + dx - self.GripDragFraction * self:GetGripSize () - self:GetHeight ()
			self:SetScrollPosition (self:GripPositionToScrollPosition (x))
		end
	)
end

function self:dtor ()
	self.LeftButtonBehaviour :dtor ()
	self.RightButtonBehaviour:dtor ()
end

-- IView
-- Content layout
function self:GetPreferredSize (maximumWidth, maximumHeight)
	return maximumWidth or self:GetWidth (), self:GetThickness ()
end

-- Internal
function self:OnLayout (w, h)
	self.LeftButton:SetRectangle (0, 0, h, h)
	self.RightButton:SetRectangle (w - h, 0, h, h)
	
	self.Grip:SetRectangle (h + self:ScrollPositionToGripPosition (self:GetAnimatedScrollPosition ()), 0, self:GetGripSize (), h)
end

-- Scrollbar
function self:GetOrientation ()
	return Glass.Orientation.Horizontal
end

function self:GetTrackSize ()
	return self:GetWidth () - self:GetHeight () * 2
end

-- Internal
function self:ScrollTrack (x, y)
	local scrollPosition = self:GripPositionToScrollPosition (x - self:GetHeight () - 0.5 * self.Grip:GetWidth ())
	if x < self.Grip:GetX () + 0.5 * self.Grip:GetWidth () then
		self:SetScrollPosition (math.max (scrollPosition, self:GetScrollPosition () - self:GetSmallIncrement ()))
	else
		self:SetScrollPosition (math.min (scrollPosition, self:GetScrollPosition () + self:GetSmallIncrement ()))
	end
end

-- HorizontalScrollbar
function self:ScrollLeft (animated)
	self:ScrollSmallIncrements (-1, animated)
end

function self:ScrollRight (animated)
	self:ScrollSmallIncrements (1, animated)
end
