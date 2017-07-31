local self = {}
Glass.ButtonBehaviour = Class (self)

self.Changed = Event ()
self.HoveredChanged = Event ()
self.PressedChanged = Event ()

function self:ctor (view)
	self.View = view
	
	self.Pressed = false
	self.Hovered = false
	
	self.View.MouseEnter:AddListener ("Glass.ButtonBehaviour." .. self:GetHashCode (), self, self.OnMouseEnter)
	self.View.MouseLeave:AddListener ("Glass.ButtonBehaviour." .. self:GetHashCode (), self, self.OnMouseLeave)
	self.View.MouseDown :AddListener ("Glass.ButtonBehaviour." .. self:GetHashCode (), self, self.OnMouseDown)
	self.View.MouseUp   :AddListener ("Glass.ButtonBehaviour." .. self:GetHashCode (), self, self.OnMouseUp)
end

function self:dtor ()
	self.View.MouseEnter:RemoveListener ("Glass.ButtonBehaviour." .. self:GetHashCode ())
	self.View.MouseLeave:RemoveListener ("Glass.ButtonBehaviour." .. self:GetHashCode ())
	self.View.MouseDown :RemoveListener ("Glass.ButtonBehaviour." .. self:GetHashCode ())
	self.View.MouseUp   :RemoveListener ("Glass.ButtonBehaviour." .. self:GetHashCode ())
end

-- ButtonBehaviour
function self:IsPressed ()
	return self.Pressed
end

function self:IsHovered ()
	return self.Hovered
end

function self:OnMouseEnter ()
	self:SetHovered (true)
end

function self:OnMouseLeave ()
	self:SetHovered (false)
end

function self:OnMouseDown (mouseButtons, x, y)
	if mouseButtons == Glass.MouseButtons.Left then
		self:SetPressed (true)
		if self.View then
			self.View:CaptureMouse ()
		end
	end
end

function self:OnMouseMove (mouseButtons, x, y)
	if self.View then
		self:SetHovered (0 <= x and x < self.View:GetWidth  () and
		                 0 <= y and y < self.View:GetHeight ())
	end
end

function self:OnMouseUp (mouseButtons, x, y)
	if mouseButtons == Glass.MouseButtons.Left then
		self:SetPressed (false)
		if self.View then
			self.View:ReleaseMouse ()
		end
	end
end

-- Internal
function self:SetHovered (hovered)
	if self.Hovered == hovered then return end
	
	self.Hovered = hovered
	
	self.HoveredChanged:Dispatch (self.Hovered)
	self.Changed:Dispatch ()
end

function self:SetPressed (pressed)
	if self.Pressed == pressed then return end
	
	self.Pressed = pressed
	
	self.PressedChanged:Dispatch (self.Pressed)
	self.Changed:Dispatch ()
end
