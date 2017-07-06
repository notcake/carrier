local self = {}
GarrysMod.View = Class (self, IView)

self.Layout = Event ()

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
function self:Render (w, h, render2d)
end

-- View
local defaultRender = self.Render
function self:GetPanel ()
	if not self.Panel or
	   not self.Panel:IsValid () then
		self.Panel = self:CreatePanel ()
		PanelViews.Register (self.Panel, self)
		
		local paint = self.Panel.Paint
		self.Panel.Paint = function (_, w, h)
			if self.Render == defaultRender then
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
