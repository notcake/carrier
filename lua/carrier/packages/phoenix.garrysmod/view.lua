local self = {}
GarrysMod.View = Class (self, IView)

function self:ctor ()
	self.Panel = nil
	
	self.LayoutEngine = nil
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
	return self:GetPanel ():GetPos ()
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

-- Internal
function self:OnMouseDown (mouseButtons, x, y) end
function self:OnMouseMove (mouseButtons, x, y) end
function self:OnMouseUp   (mouseButtons, x, y) end

function self:OnMouseWheel (delta) end

function self:OnMouseEnter () end
function self:OnMouseLeave () end

function self:Render (w, h, render2d) end

-- View
function self:GetPanel ()
	if not self.Panel or
	   not self.Panel:IsValid () then
		self.Panel = self:CreatePanel ()
		PanelViews.Register (self.Panel, self)
		
		local mousePressed = self.Panel.OnMousePressed
		self.Panel.OnMousePressed = function (_, mouseCode)
			self:CallDefaultFiltered ("OnMouseDown", mousePressed, mouseCode)
			
			local mouseButtons = MouseButtons.FromNative (mouseCode)
			local x, y = self.Panel:CursorPos ()
			self:OnMouseDown (mouseButtons, x, y)
			self.MouseDown:Dispatch (mouseButtons, x, y)
		end
		
		local mouseReleased = self.Panel.OnMouseReleased
		self.Panel.OnMouseReleased = function (_, mouseCode)
			self:CallDefaultFiltered ("OnMouseUp", mouseReleased, mouseCode)
			
			local mouseButtons = MouseButtons.FromNative (mouseCode)
			local x, y = self.Panel:CursorPos ()
			self:OnMouseUp (mouseButtons, x, y)
			self.MouseUp:Dispatch (mouseButtons, x, y)
		end
		
		local mouseWheeled = self.Panel.OnMouseWheeled
		self.Panel.OnMouseWheeled = function (_, delta)
			self:CallDefaultFiltered ("OnMouseWheel", mouseWheeled, delta)
			
			self:OnMouseWheel (delta)
			self.MouseWheel:Dispatch (delta)
		end
		
		local cursorMoved = self.Panel.OnCursorMoved
		self.Panel.OnCursorMoved = function (_, x, y)
			self:CallDefaultFiltered ("OnMouseMove", cursorMoved, x, y)
			
			local mouseButtons = MouseButtons.Poll ()
			local x, y = self.Panel:CursorPos ()
			self:OnMouseMove (mouseButtons, x, y)
			self.MouseMove:Dispatch (mouseButtons, x, y)
		end
		
		local cursorEntered = self.Panel.OnCursorEntered
		self.Panel.OnCursorEntered = function (_)
			self:CallDefaultFiltered ("OnMouseEnter", cursorEntered)
			
			self:OnMouseEnter ()
			self.MouseEnter:Dispatch ()
		end
		
		local cursorExited = self.Panel.OnCursorExited
		self.Panel.OnCursorExited = function (_)
			self:CallDefaultFiltered ("OnMouseLeave", cursorEntered)
			
			self:OnMouseLeave ()
			self.MouseLeave:Dispatch ()
		end
		
		local paint = self.Panel.Paint
		self.Panel.Paint = function (_, w, h)
			self:CallDefaultFiltered ("Render", paint, w, h)
			
			self:Render (w, h, Photon.Render2d.Instance)
		end
		
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
function self:CallDefaultFiltered (methodName, default, ...)
	if self [methodName] == methodTable [methodName] then
		if default then
			default (self.Panel, ...)
		end
	end
end
