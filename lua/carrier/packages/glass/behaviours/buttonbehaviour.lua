local self = {}
Glass.ButtonBehaviour = Class(self)

self.Changed = Event()
self.HoveredChanged = Event()
self.PressedChanged = Event()

function self:ctor(view, autobind)
	self.View = view
	
	self.RawPressed = false
	self.Pressed = false
	self.Hovered = false
	
	if self.View and autobind ~= false then
		local listenerName = "Glass.ButtonBehaviour." .. self:GetHashCode()
		self.View.MouseEnter:AddListener(listenerName, self, self.OnMouseEnter)
		self.View.MouseLeave:AddListener(listenerName, self, self.OnMouseLeave)
		self.View.MouseDown :AddListener(listenerName, self, self.OnMouseDown)
		self.View.MouseMove :AddListener(listenerName, self, self.OnMouseMove)
		self.View.MouseUp   :AddListener(listenerName, self, self.OnMouseUp)
	end
end

function self:dtor()
	local listenerName = "Glass.ButtonBehaviour." .. self:GetHashCode()
	self.View.MouseEnter:RemoveListener(listenerName)
	self.View.MouseLeave:RemoveListener(listenerName)
	self.View.MouseDown :RemoveListener(listenerName)
	self.View.MouseMove :RemoveListener(listenerName)
	self.View.MouseUp   :RemoveListener(listenerName)
end

-- ButtonBehaviour
function self:IsPressed()
	return self.Pressed
end

function self:IsHovered()
	return self.Hovered
end

function self:IsMouseCaptured()
	return self.RawPressed
end

function self:OnMouseEnter()
	self:SetHovered(true)
end

function self:OnMouseLeave()
	self:SetHovered(false)
end

function self:OnMouseDown(mouseButtons, x, y)
	if mouseButtons == Glass.MouseButtons.Left then
		self:SetPressed(true)
		self.RawPressed = true
		if self.View then
			self.View:CaptureMouse()
		end
	end
end

function self:OnMouseMove(mouseButtons, x, y)
	if self.View and
	   self.RawPressed then
		self:SetPressed(0 <= x and x < self.View:GetWidth () and
		                 0 <= y and y < self.View:GetHeight())
	end
end

function self:OnMouseUp(mouseButtons, x, y)
	if mouseButtons == Glass.MouseButtons.Left then
		self:SetPressed(false)
		self.RawPressed = false
		if self.View then
			self.View:ReleaseMouse()
		end
	end
end

-- Internal
function self:SetHovered(hovered)
	if self.Hovered == hovered then return end
	
	self.Hovered = hovered
	
	self.HoveredChanged:Dispatch(self.Hovered)
	self.Changed:Dispatch()
end

function self:SetPressed(pressed)
	if self.Pressed == pressed then return end
	
	self.Pressed = pressed
	
	self.PressedChanged:Dispatch(self.Pressed)
	self.Changed:Dispatch()
end
