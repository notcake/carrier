local self = {}
GarrysMod.View = Class (self, Core.IView)

self.Layout = Event ()

function self:ctor ()
end

function self:dtor ()
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
	return panel:IsValid () and panel.__view or nil
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
	self:GetPanel ():SetPos (x, y)
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

-- Appearance
function self:IsVisible ()
	return self:GetPanel ():IsVisible ()
end

function self:SetVisible (visible)
	self:GetPanel ():SetVisible (visible)
end

-- View
function self:GetPanel ()
	if not self.Panel or
	   not self.Panel:IsValid () then
		self.Panel = self:CreatePanel ()
		self.Panel.__view = self
		
		self.Panel.PerformLayout = function ()
			self:OnLayout ()
			self.Layout:Dispatch ()
		end
	end
	
	return self.Panel
end

function self:CreatePanel ()
	return vgui.Create ("DPanel")
end
