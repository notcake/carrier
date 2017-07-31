local self = {}
Glass.DragBehaviour = Class (self)

self.Started = Event ()
self.Updated = Event ()
self.Ended   = Event ()

function self:ctor (view, autobind)
	self.View = view
	
	-- Dragging only starts when the mouse has moved enough
	-- or the mouse is pressed for long enough
	self.Pressed        = false
	self.PressStartTime = nil
	self.DragStarted    = false
	
	-- Mouse position in parent coordinates at start of press
	self.PressStartX = nil
	self.PressStartY = nil
	
	if self.View and autobind ~= false then
		self.View.MouseDown :AddListener ("Glass.DragBehaviour." .. self:GetHashCode (), self, self.OnMouseDown)
		self.View.MouseMove :AddListener ("Glass.DragBehaviour." .. self:GetHashCode (), self, self.OnMouseMove)
		self.View.MouseUp   :AddListener ("Glass.DragBehaviour." .. self:GetHashCode (), self, self.OnMouseUp)
	end
end

function self:dtor ()
	self.View.MouseDown :RemoveListener ("Glass.DragBehaviour." .. self:GetHashCode ())
	self.View.MouseMove :RemoveListener ("Glass.DragBehaviour." .. self:GetHashCode ())
	self.View.MouseUp   :RemoveListener ("Glass.DragBehaviour." .. self:GetHashCode ())
end

-- DragBehaviour
function self:GetStartPosition ()
	return self.PressStartX, self.PressStartY
end

function self:IsPressed ()
	return self.Pressed
end

function self:IsStarted ()
	return self.DragStarted
end

function self:OnMouseDown (mouseButtons, x, y)
	if mouseButtons == Glass.MouseButtons.Left then
		self.Pressed = true
		self.PressStartTime = Clock ()
		self.DragStarted = false
		
		-- Convert to parent coordinates
		local dx, dy = 0, 0
		if self.View then
			dx, dy = self.View:GetPosition ()
		end
		
		self.PressStartX, self.PressStartY = x + dx, y + dy
		
		if self.View then
			self.View:CaptureMouse ()
		end
	end
end

function self:OnMouseMove (mouseButtons, x, y)
	if self.Pressed then
		-- Convert to parent coordinates
		local dx, dy = 0, 0
		if self.View then
			dx, dy = self.View:GetPosition ()
		end
		
		local x, y = x + dx, y + dy
		local dx, dy = x - self.PressStartX, y - self.PressStartY
		
		if not self.DragStarted and
		   ((Clock () - self.PressStartTime > 0.5) or (dx * dx + dy * dy >= 64)) then
			self.DragStarted = true
			self.Started:Dispatch ()
		end
		
		if not self.DragStarted then return end
		
		self.Updated:Dispatch (dx, dy)
	end
end

function self:OnMouseUp (mouseButtons, x, y)
	if mouseButtons == Glass.MouseButtons.Left then
		self.Pressed = false
		if self.View then
			self.View:ReleaseMouse ()
		end
		
		self.Ended:Dispatch ()
	end
end

-- Internal
