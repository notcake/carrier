local self = {}
GarrysMod.View = Class (self, IView)

function self:ctor ()
	self.Panel = nil
	
	self.RectangleAnimator = nil
	
	self.Cursor = Glass.Cursor.Default
	
	self.Animations = nil
	self.ThinkHandlerInstalled = false
end

function self:dtor ()
	PanelViews.Unregister (self.Panel, self)
	
	if self.Panel and
	   self.Panel:IsValid () then
		self.Panel:Remove ()
		self.Panel = nil
	end
end

-- IView
-- Hierarchy
function self:AddChild (view)
	view:GetPanel ():SetParent (self:GetPanel ())
end

function self:RemoveChild (view)
	view:GetPanel ():SetParent (nil)
end

function self:GetParent ()
	return PanelViews.GetView (self:GetPanel ():GetParent ())
end

function self:SetParent (view)
	if view then
		view:AddChild (self)
	else
		self:GetPanel ():SetParent (nil)
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
	local x, y = self:GetPosition ()
	local w, h = self:GetSize ()
	return x, y, w, h
end

function self:SetRectangle (x, y, w, h, animator)
	if animator == true then animator = self:CreateDefaultAnimation () end
	
	self:SetPosition (x, y, animator)
	self:SetSize     (w, h, animator)
end

function self:GetPosition ()
	local parent = self:GetParent ()
	local dx, dy = 0, 0
	if parent then dx, dy = parent:GetContainerPosition () end
	
	local x, y = self:GetPanel ():GetPos ()
	return x - dx, y - dy
end

function self:SetPosition (x, y)
	local parent = self:GetParent ()
	local dx, dy = 0, 0
	if parent then dx, dy = parent:GetContainerPosition () end
	
	self:GetPanel ():SetPos (x + dx, y + dy)
end

local View_SetPosition = self.SetPosition
function self:SetX (x)
	View_SetPosition (self, x, self:GetY ())
end

function self:SetY (y)
	View_SetPosition (self, self:GetX (), y)
end

self.SetPosition = AnimatedRectangleSetter2 (self.SetPosition, "Position")
self.SetX        = AnimatedRectangleSetter1 (self.SetX, "X")
self.SetY        = AnimatedRectangleSetter1 (self.SetY, "Y")

function self:GetSize ()
	return self:GetPanel ():GetSize ()
end

function self:GetWidth ()
	return self:GetPanel ():GetWide ()
end

function self:GetHeight ()
	return self:GetPanel ():GetTall ()
end

function self:SetSize (w, h)
	self:GetPanel ():SetSize (w, h)
end

function self:SetWide (w)
	self:GetPanel ():SetWide (w)
end

function self:SetHeight (h)
	self:GetPanel ():SetTall (h)
end

self.SetSize   = AnimatedRectangleSetter2 (self.SetSize,   "Size")
self.SetWidth  = AnimatedRectangleSetter1 (self.SetWidth,  "Width")
self.SetHeight = AnimatedRectangleSetter1 (self.SetHeight, "Height")

function self:BringToFront ()
	self:GetPanel ():MoveToFront ()
end

function self:SendToBack ()
	self:GetPanel ():MoveToBack ()
end

-- Content layout
function self:InvalidateLayout ()
	self:GetPanel ():InvalidateLayout ()
end

-- Appearance
function self:IsVisible ()
	return self:GetPanel ():IsVisible ()
end

function self:SetVisible (visible)
	self:GetPanel ():SetVisible (visible)
end

-- Mouse
function self:GetCursor ()
	return self.Cursor
end

function self:SetCursor (cursor)
	self.Cursor = cursor
	self:GetPanel ():SetCursor (Cursor.ToNative (cursor))
end

function self:GetMousePosition ()
	local x, y = self:GetPanel ():CursorPos ()
	
	-- Fix coordinates by inverting the bad ScreenToLocal transform
	-- This happens when view layout is done outside of a legitimate layout event
	x, y = self:GetPanel ():LocalToScreen (x, y)
	
	-- Manual ScreenToLocal
	local panel = self:GetPanel ()
	while panel do
		local dx, dy = panel:GetPos ()
		x, y = x - dx, y - dy
		
		panel = panel:GetParent ()
	end
	
	return x, y
end

function self:CaptureMouse ()
	MouseEventRouter:OnCaptureMouse (self)
	self:GetPanel ():MouseCapture (true)
end

function self:ReleaseMouse ()
	self:GetPanel ():MouseCapture (false)
	MouseEventRouter:OnReleaseMouse (self)
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
local DummyPanel = {}
function DummyPanel:IsValid ()
	Error ("Cannot use View:GetPanel () within View:CreatePanel ()!")
end
function DummyPanel:Remove () end

function self:GetPanel ()
	if not self.Panel or
	   not self.Panel:IsValid () then
		self.Panel = DummyPanel
		self.Panel = self:CreatePanel ()
		PanelViews.Register (self.Panel, self)
		
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
		
		local performLayout = self.Panel.PerformLayout
		self.Panel.PerformLayout = function (_, w, h)
			if performLayout then
				performLayout (_, w, h)
			end
			
			self:OnLayout (self:GetContainerSize ())
			self.Layout:Dispatch ()
		end
		
		local setVisible = self.Panel.SetVisible
		self.Panel.SetVisible = function (_, visible)
			if _:IsVisible () == visible then return end
			
			setVisible (_, visible)
			
			self:OnVisibleChanged (visible)
			self.VisibleChanged:Dispatch (visible)
		end
	end
	
	return self.Panel
end

-- Internal
function self:CreatePanel ()
	local panel = vgui.Create ("DPanel")
	panel.Paint = function (self, w, h) end
	
	return panel
end

function self:InjectPanel (panel)
	if self.Panel and self.Panel:IsValid () then
		self.Panel:Remove ()
	end
	
	self.Panel = panel
end

local methodTable = self
function self:InstallPanelEventHandler (panelMethodName, methodName, handler)
	local defaultMethod = self.Panel [panelMethodName]
	
	-- Suppress default method if an override is present
	-- but always call the handler so that events get fired.
	if self [methodName] == methodTable [methodName] and
	   defaultMethod then
		self.Panel [panelMethodName] = function (_, ...)
			defaultMethod (self.Panel, ...)
			return handler (...)
		end
	else
		self.Panel [panelMethodName] = function (_, ...)
			return handler (...)
		end
	end
end

function self:InstallThinkHandler ()
	if self.ThinkHandlerInstalled then return end
	
	self.ThinkHandlerInstalled = true
	
	local defaultThink = self.Panel.Think
	self.Panel.Think = function (_)
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
			self.Panel.Think = defaultThink
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
			View_SetPosition (self, x, y)
			self:GetPanel ():SetSize (w, h)
		end
	)
	
	return self.RectangleAnimator
end

function self:CreateDefaultAnimator ()
	return self:CreateAnimator (Glass.Interpolators.Linear (), 0.25)
end
