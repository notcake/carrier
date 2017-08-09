local self = {}
GarrysMod.View = Class (self, IView)

function self:ctor ()
	self.Environment = GarrysMod.Environment
	
	self.Handle = nil
	
	self.RectangleAnimator = nil
	
	self.Cursor = Glass.Cursor.Default
	
	self.Animations = nil
	self.ThinkHandlerInstalled = false
end

function self:dtor ()
	GarrysMod.Environment:UnregisterView (self.Handle, self)
	
	if self.Handle and
	   self.Handle:IsValid () then
		self.Handle:Remove ()
		self.Handle = nil
	end
end

-- IView
-- Environment
function self:GetEnvironment ()
	return self.Environment
end
local DummyPanel = {}
function DummyPanel:IsValid ()
	Error ("Cannot use View:GetHandle () within View:CreatePanel ()!")
end
function DummyPanel:Remove () end

function self:GetHandle ()
	if not self.Handle or
	   not self.Handle:IsValid () then
		self.Handle = DummyPanel
		self.Handle = self:CreatePanel ()
		GarrysMod.Environment:RegisterView (self.Handle, self)
		
		self:InstallPanelEventHandler ("OnMousePressed", "OnMouseDown",
			function (mouseCode)
				local mouseButtons = MouseButtons.FromNative (mouseCode)
				MouseEventRouter:OnMouseDown (self, mouseButtons, self:GetMousePosition ())
			end
		)
		
		self:InstallPanelEventHandler ("OnMouseReleased", "OnMouseUp",
			function (mouseCode)
				local mouseButtons = MouseButtons.FromNative (mouseCode)
				MouseEventRouter:OnMouseUp (self, mouseButtons, self:GetMousePosition ())
			end
		)
		
		self:InstallPanelEventHandler ("OnMouseWheeled", "OnMouseWheel",
			function (delta)
				return MouseEventRouter:OnMouseWheel (self, delta)
			end
		)
		
		self:InstallPanelEventHandler ("OnCursorMoved", "OnMouseMove",
			function (x, y)
				local mouseButtons = MouseButtons.Poll ()
				MouseEventRouter:OnMouseMove (self, mouseButtons, self:GetMousePosition ())
			end
		)
		
		self:InstallPanelEventHandler ("OnCursorEntered", "OnMouseEnter",
			function ()
				MouseEventRouter:OnMouseEnter (self)
			end
		)
		
		self:InstallPanelEventHandler ("OnCursorExited", "OnMouseLeave",
			function ()
				MouseEventRouter:OnMouseLeave (self)
			end
		)
		
		self:InstallPanelEventHandler ("Paint", "Render",
			function (w, h)
				self:Render (w, h, Photon.Render2d)
			end
		)
		
		local performLayout = self.Handle.PerformLayout
		self.Handle.PerformLayout = function (_, w, h)
			if performLayout then
				performLayout (_, w, h)
			end
			
			self:OnLayout (self:GetContainerSize ())
			self.Layout:Dispatch ()
		end
		
		local setVisible = self.Handle.SetVisible
		self.Handle.SetVisible = function (_, visible)
			if _:IsVisible () == visible then return end
			
			setVisible (_, visible)
			
			self:OnVisibleChanged (visible)
			self.VisibleChanged:Dispatch (visible)
		end
	end
	
	return self.Handle
end

function self:IsHandleCreated ()
	return self.Handle and self.Handle:IsValid () or false
end

-- Hierarchy
function self:AddChild (view)
	self.Environment:AddChild (self, self:GetHandle (), view)
end

function self:RemoveChild (view)
	self.Environment:RemoveChild (self, self:GetHandle (), view)
end

function self:GetParent ()
	return self.Environment:GetParent (self, self:GetHandle ())
end

function self:SetParent (view)
	if view then
		view:AddChild (self)
	else
		self.Environment:SetParent (self, self:GetHandle (), nil)
	end
end

-- Layout
local function AnimatedRectangleSetter1 (setter, name)
	local setterName = "Set" .. name
	return function (self, x, animator)
		if animator == true then animator = self:CreateDefaultAnimation () end
		
		if not animator then
			setter (self, x)
		else
			self:AddAnimation (self:CreateRectangleAnimator ())
		end
		
		if not self.RectangleAnimator then return end
		self.RectangleAnimator [setterName] (self.RectangleAnimator, Clock (), x, animator)
	end
end

local function AnimatedRectangleSetter2 (setter, name)
	local setterName = "Set" .. name
	return function (self, x1, x2, animator)
		if animator == true then animator = self:CreateDefaultAnimation () end
		
		if not animator then
			setter (self, x1, x2)
		else
			self:AddAnimation (self:CreateRectangleAnimator ())
		end
		
		if not self.RectangleAnimator then return end
		self.RectangleAnimator [setterName] (self.RectangleAnimator, Clock (), x1, x2, animator)
	end
end

function self:GetRectangle ()
	return self.Environment:GetRectangle (self, self:GetHandle ())
end

function self:SetRectangle (x, y, w, h, animator)
	if animator == true then animator = self:CreateDefaultAnimation () end
	
	self:SetPosition (x, y, animator)
	self:SetSize     (w, h, animator)
end

function self:GetPosition ()
	return self.Environment:GetPosition (self, self:GetHandle ())
end

function self:SetPosition (x, y)
	self.Environment:SetPosition (self, self:GetHandle (), x, y)
end

function self:SetX (x)
	self.Environment:SetPosition (self, self:GetHandle (), x, self:GetY ())
end

function self:SetY (y)
	self.Environment:SetPosition (self, self:GetHandle (), self:GetX (), y)
end

self.SetPosition = AnimatedRectangleSetter2 (self.SetPosition, "Position")
self.SetX        = AnimatedRectangleSetter1 (self.SetX, "X")
self.SetY        = AnimatedRectangleSetter1 (self.SetY, "Y")

function self:GetSize ()
	return self.Environment:GetSize (self, self:GetHandle ())
end

function self:GetWidth ()
	local w, _ = self.Environment:GetSize (self, self:GetHandle ())
	return w
end

function self:GetHeight ()
	local _, h = self.Environment:GetSize (self, self:GetHandle ())
	return h
end

function self:SetSize (w, h)
	self.Environment:SetSize (self, self:GetHandle (), w, h)
end

function self:SetWide (w)
	self.Environment:SetSize (self, self:GetHandle (), w, self:GetHeight ())
end

function self:SetHeight (h)
	self.Environment:SetSize (self, self:GetHandle (), self:GetWidth (), h)
end

self.SetSize   = AnimatedRectangleSetter2 (self.SetSize,   "Size")
self.SetWidth  = AnimatedRectangleSetter1 (self.SetWidth,  "Width")
self.SetHeight = AnimatedRectangleSetter1 (self.SetHeight, "Height")

function self:BringToFront ()
	self.Environment:BringToFront (self, self:GetHandle ())
end

function self:SendToBack ()
	self.Environment:SendToBack (self, self:GetHandle ())
end

-- Content layout
function self:InvalidateLayout ()
	self.Environment:InvalidateLayout (self, self:GetHandle ())
end

-- Appearance
function self:IsVisible ()
	return self.Environment:IsVisible (self, self:GetHandle ())
end

function self:SetVisible (visible)
	self.Environment:SetVisible (self, self:GetHandle (), visible)
end

-- Mouse
function self:GetCursor ()
	return self.Cursor
end

function self:SetCursor (cursor)
	self.Cursor = cursor
	self.Environment:SetCursor (self, self:GetHandle (), cursor)
end

function self:GetMousePosition ()
	return self.Environment:GetMousePosition (self, self:GetHandle ())
end

function self:CaptureMouse ()
	self.Environment:CaptureMouse (self, self:GetHandle ())
end

function self:ReleaseMouse ()
	self.Environment:ReleaseMouse (self, self:GetHandle ())
end

function self:IsMouseEventConsumer ()
	return self.ConsumesMouseEvents
end

function self:SetConsumesMouseEvents (consumesMouseEvents)
	self.ConsumesMouseEvents = consumesMouseEvents
end

-- Animations
function self:AddAnimation (animation)
	self.Animations = self.Animations or {}
	self.Animations [animation] = true
	
	self:InstallThinkHandler ()
end

function self:RemoveAnimation (animation)
	if not self.Animations then return end
	
	self.Animations [animation] = nil
end

function self:CreateAnimation (updater)
	local animation = Glass.Animation (Clock (), updater)
	
	self:AddAnimation (animation)
	return animation
end

function self:CreateAnimator (interpolator, duration, updater)
	local animator = Glass.Animator (Clock (), interpolator, duration)
	if updater then
		animator.Updated:AddListener (updater)
	end
	
	self:AddAnimation (animator)
	return animator
end

-- Internal
function self:OnMouseDown (mouseButtons, x, y) end
function self:OnMouseMove (mouseButtons, x, y) end
function self:OnMouseUp   (mouseButtons, x, y) end

function self:OnMouseWheel (delta) end

function self:OnMouseEnter () end
function self:OnMouseLeave () end

function self:Render (w, h, render2d) end

-- View
-- Internal
function self:CreatePanel ()
	local panel = vgui.Create ("DPanel")
	panel.Paint = function (self, w, h) end
	
	return panel
end

function self:InjectPanel (panel)
	if self.Handle and self.Handle:IsValid () then
		self.Handle:Remove ()
	end
	
	self.Handle = panel
end

local methodTable = self
function self:InstallPanelEventHandler (panelMethodName, methodName, handler)
	local defaultMethod = self.Handle [panelMethodName]
	
	-- Suppress default method if an override is present
	-- but always call the handler so that events get fired.
	if self [methodName] == methodTable [methodName] and
	   defaultMethod then
		self.Handle [panelMethodName] = function (_, ...)
			defaultMethod (self.Handle, ...)
			return handler (...)
		end
	else
		self.Handle [panelMethodName] = function (_, ...)
			return handler (...)
		end
	end
end

function self:InstallThinkHandler ()
	if self.ThinkHandlerInstalled then return end
	
	self.ThinkHandlerInstalled = true
	
	local defaultThink = self.Handle.Think
	self.Handle.Think = function (_)
		if defaultThink then
			defaultThink (_)
		end
		
		-- Run animations
		if self.Animations then
			local t = Clock ()
			for animation, _ in pairs (self.Animations) do
				local uncompleted = animation:Update (t)
				if not uncompleted then
					self.Animations [animation] = nil
				end
			end
		end
		
		-- Remove Think handler if all
		-- animations have completed
		if not self.Animations or
		   not next (self.Animations) then
			self.Handle.Think = defaultThink
			self.ThinkHandlerInstalled = false
		end
	end
end

function self:CreateRectangleAnimator ()
	if self.RectangleAnimator then return self.RectangleAnimator end
	
	local x, y, w, h = self:GetRectangle ()
	self.RectangleAnimator = Glass.RectangleAnimator (x, y, w, h)
	self.RectangleAnimator.Updated:AddListener (
		function (x, y, w, h)
			self.Environment:SetRectangle (self, self:GetHandle (), x, y, w, h)
		end
	)
	
	return self.RectangleAnimator
end

function self:CreateDefaultAnimator ()
	return self:CreateAnimator (Glass.Interpolators.Linear (), 0.25)
end
