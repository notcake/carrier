local self = {}
GarrysMod.VerticalScrollbar = Class (self, Scrollbar)

function self:ctor ()
	self.UpButton = Scrollbar.Button (Glass.Direction.Up)
	self.UpButton:SetParent (self)
	self.UpButton.MouseDown:AddListener (
		function (mouseButtons, x, y)
			self:CreateAnimation (
				function (t0, t)
					self:ScrollUp (true)
				end
			)
		end
	)
	self.UpButton.MouseUp:AddListener (
		function (mouseButtons, x, y)
			self:ScrollUp (true)
		end
	)
	self.DownButton = Scrollbar.Button (Glass.Direction.Down)
	self.DownButton:SetParent (self)
	self.DownButton.MouseDown:AddListener (
		function (mouseButtons, x, y)
			self:CreateAnimation (
				function (t0, t)
					self:ScrollDown (true)
				end
			)
		end
	)
	self.DownButton.MouseUp:AddListener (
		function (mouseButtons, x, y)
			self:ScrollDown (true)
		end
	)
	
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

-- VerticalScrollbar
function self:ScrollUp (animated)
	self:ScrollSmallIncrements (-1, animated)
end

function self:ScrollDown (animated)
	self:ScrollSmallIncrements (1, animated)
end
