local self = {}
Core.IView = Interface (self)

self.Layout     = Event ()

self.MouseDown  = Event ()
self.MouseMove  = Event ()
self.MouseUp    = Event ()
self.MouseWheel = Event ()
self.MouseEnter = Event ()
self.MouseLeave = Event ()

function self:ctor ()
end

-- Hierarchy
function self:AddChild (view)
	Error ("IView:AddChild : Not implemented.")
end

function self:RemoveChild (view)
	Error ("IView:RemoveChild : Not implemented.")
end

function self:GetParent ()
	Error ("IView:GetParent : Not implemented.")
end

function self:SetParent (view)
	Error ("IView:SetParent : Not implemented.")
end

-- Layout
function self:GetPosition ()
	Error ("IView:GetPosition : Not implemented.")
end

function self:SetPosition (x, y)
	Error ("IView:SetPosition : Not implemented.")
end

function self:GetSize ()
	Error ("IView:GetSize : Not implemented.")
end

function self:SetSize (w, h)
	Error ("IView:SetSize : Not implemented.")
end

function self:GetRectangle ()
	local x, y = self:GetPosition ()
	local w, h = self:GetSize ()
	return x, y, w, h
end

function self:SetRectangle (x, y, w, h)
	self:SetPosition (x, y)
	self:SetSize (w, h)
end

function self:Center ()
	Error ("IView:Center : Not implemented.")
end

-- Content layout
function self:GetContentPosition ()
	return 0, 0
end

function self:GetContentSize ()
	return self:GetSize ()
end

function self:GetContentRectangle ()
	return 0, 0, self:GetSize ()
end

-- Appearance
function self:IsVisible ()
	Error ("IView:IsVisible : Not implemented.")
end

function self:SetVisible (visible)
	Error ("IView:SetVisible : Not implemented.")
end

-- Mouse
function self:GetCursor ()
	Error ("IView:GetCursor : Not implemented.")
end

function self:SetCursor (cursor)
	Error ("IView:SetCursor : Not implemented.")
end

-- Internal
function self:OnLayout (contentWidth, contentHeight) end

function self:OnMouseDown (mouseButtons, x, y) end
function self:OnMouseMove (mouseButtons, x, y) end
function self:OnMouseUp   (mouseButtons, x, y) end

function self:OnMouseWheel (delta) end

function self:OnMouseEnter () end
function self:OnMouseLeave () end

function self:Render (w, h, render2d) end
