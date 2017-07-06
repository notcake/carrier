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
local methodTable = self
function self:GetPanel ()
	if not self.Panel or
	   not self.Panel:IsValid () then
		self.Panel = self:CreatePanel ()
		PanelViews.Register (self.Panel, self)
		
		local mousePressed  = self.Panel.OnMousePressed
		local mouseReleased = self.Panel.OnMouseReleased
		local mouseWheeled  = self.Panel.OnMouseWheeled
		local cursorMoved   = self.Panel.OnCursorMoved
		local cursorEntered = self.Panel.OnCursorEntered
		local cursorExited  = self.Panel.OnCursorExited
		self.Panel.OnMousePressed = function (_, mouseCode)
			if self.OnMouseDown == methodTable.OnMouseDown then
				if mousePressed then
					mousePressed (_, mouseCode)
				end
			end
			
			local mouseButtons = MouseButtons.FromNative (mouseCode)
			local x, y = self.Panel:CursorPos ()
			self:OnMouseDown (mouseButtons, x, y)
			self.MouseDown:Dispatch (mouseButtons, x, y)
		end
		self.Panel.OnMouseReleased = function (_, mouseCode)
			if self.OnMouseUp == methodTable.OnMouseUp then
				if mouseReleased then
					mouseReleased (_, mouseCode)
				end
			end
			
			local mouseButtons = MouseButtons.FromNative (mouseCode)
			local x, y = self.Panel:CursorPos ()
			self:OnMouseUp (mouseButtons, x, y)
			self.MouseUp:Dispatch (mouseButtons, x, y)
		end
		self.Panel.OnMouseWheeled = function (_, delta)
			if self.OnMouseWheel == methodTable.OnMouseWheel then
				if mouseWheeled then
					mouseWheeled (_, delta)
				end
			end
			
			self:OnMouseWheel (delta)
			self.MouseWheel:Dispatch (delta)
		end
		self.Panel.OnCursorMoved = function (_, x, y)
			if self.OnMouseMove == methodTable.OnMouseMove then
				if cursorMoved then
					cursorMoved (_, x, y)
				end
			end
			
			local mouseButtons = MouseButtons.Poll ()
			local x, y = self.Panel:CursorPos ()
			self:OnMouseMove (mouseButtons, x, y)
			self.MouseMove:Dispatch (mouseButtons, x, y)
		end
		self.Panel.OnCursorEntered = function (_)
			if self.OnMouseEnter == methodTable.OnMouseEnter then
				if cursorEntered then
					cursorEntered (_)
				end
			end
			
			self:OnMouseEnter ()
			self.MouseEnter:Dispatch ()
		end
		self.Panel.OnCursorExited = function (_)
			if self.OnMouseLeave == methodTable.OnMouseLeave then
				if cursorExited then
					cursorExited (_)
				end
			end
			
			self:OnMouseLeave ()
			self.MouseLeave:Dispatch ()
		end
		
		local paint = self.Panel.Paint
		self.Panel.Paint = function (_, w, h)
			if self.Render == methodTable.Render then
				if paint then
					paint (_, w, h)
				end
			else
				self:Render (w, h, Photon.Render2d.Instance)
			end
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

function self:CreatePanel ()
	return vgui.Create ("DPanel")
end
