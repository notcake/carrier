local self = {}
GarrysMod.View = Class (self, IView)

function self:ctor ()
	self.Panel = nil
	
	self.LayoutEngine = nil
	
	self.Cursor = Glass.Cursor.Default
	self.LastClickTime = -math.huge
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

function self:GetSize ()
	return self:GetPanel ():GetSize ()
end

function self:SetSize (w, h)
	self:GetPanel ():SetSize (w, h)
end

function self:GetWidth ()
	return self:GetPanel ():GetWide ()
end

function self:SetWidth (w)
	self:GetPanel ():SetWide (w)
end

function self:GetHeight ()
	return self:GetPanel ():GetTall ()
end

function self:SetHeight (h)
	self:GetPanel ():SetTall (h)
end

function self:Center ()
	self:GetPanel ():Center ()
end

function self:GetLayoutEngine ()
	self.LayoutEngine = self.LayoutEngine or LayoutEngine ()
	return self.LayoutEngine
end

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
	return self:GetPanel ():CursorPos ()
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
				local x, y = self.Panel:CursorPos ()
				MouseEventRouter:OnMouseDown (self, mouseButtons, x, y)
			end
		)
		
		self:InstallPanelEventHandler ("OnMouseReleased", "OnMouseUp",
			function (mouseCode)
				local mouseButtons = MouseButtons.FromNative (mouseCode)
				local x, y = self.Panel:CursorPos ()
				MouseEventRouter:OnMouseUp (self, mouseButtons, x, y)
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
				local x, y = self.Panel:CursorPos ()
				MouseEventRouter:OnMouseMove (self, mouseButtons, x, y)
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
			
			if self.LayoutEngine then
				self.LayoutEngine:Layout (self:GetContainerSize ())
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
