local self = {}
GarrysMod.View = Class (self, IView)

function self:ctor ()
	self.Panel = nil
	
	self.LayoutEngine = nil
	
	self.Cursor = Phoenix.Cursor.Default
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
	local panel = self:GetPanel ():GetParent ()
	if not panel:IsValid () then return nil end
	return PanelViews.GetView (panel)
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
	local dx, dy = self:GetParent ():GetContentPosition ()
	local x, y = self:GetPanel ():GetPos ()
	return x - dx, y - dy
end

function self:SetPosition (x, y)
	local dx, dy = self:GetParent ():GetContentPosition ()
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
	self:GetPanel ():MouseCapture (true)
end

function self:ReleaseMouse ()
	self:GetPanel ():MouseCapture (false)
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
				self:OnMouseDown (mouseButtons, x, y)
				self.MouseDown:Dispatch (mouseButtons, x, y)
			end
		)
		
		self:InstallPanelEventHandler ("OnMouseReleased", "OnMouseUp",
			function (mouseCode)
				local mouseButtons = MouseButtons.FromNative (mouseCode)
				local x, y = self.Panel:CursorPos ()
				self:OnMouseUp (mouseButtons, x, y)
				self.MouseUp:Dispatch (mouseButtons, x, y)
				
				if mouseButtons == Phoenix.MouseButtons.Left then
					if Clock () - self.LastClickTime > 0.2 then
						self.LastClickTime = Clock ()
						
						self:OnClick ()
						self.Click:Dispatch ()
					else
						self.LastClickTime = -math.huge
						
						self:OnDoubleClick ()
						self.DoubleClick:Dispatch ()
					end
				end
			end
		)
		
		self:InstallPanelEventHandler ("OnMouseWheeled", "OnMouseWheel",
			function (delta)
				self:OnMouseWheel (delta)
				self.MouseWheel:Dispatch (delta)
			end
		)
		
		self:InstallPanelEventHandler ("OnCursorMoved", "OnMouseMove",
			function (x, y)
				local mouseButtons = MouseButtons.Poll ()
				local x, y = self.Panel:CursorPos ()
				self:OnMouseMove (mouseButtons, x, y)
				self.MouseMove:Dispatch (mouseButtons, x, y)
			end
		)
		
		self:InstallPanelEventHandler ("OnCursorEntered", "OnMouseEnter",
			function ()
				self:OnMouseEnter ()
				self.MouseEnter:Dispatch ()
			end
		)
		
		self:InstallPanelEventHandler ("OnCursorExited", "OnMouseLeave",
			function ()
				self:OnMouseLeave ()
				self.MouseLeave:Dispatch ()
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
				self.LayoutEngine:Layout (self:GetContentSize ())
			end
			
			self:OnLayout (self:GetContentSize ())
			self.Layout:Dispatch ()
		end
	end
	
	return self.Panel
end

-- Internal
function self:CreatePanel ()
	return vgui.Create ("DPanel")
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
			handler (...)
		end
	else
		self.Panel [panelMethodName] = function (_, ...)
			handler (...)
		end
	end
end
