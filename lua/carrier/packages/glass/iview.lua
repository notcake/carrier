local self = {}
Glass.IView = Interface (self)

self.Layout         = Event ()
self.VisibleChanged = Event ()

self.MouseDown      = Event ()
self.MouseMove      = Event ()
self.MouseUp        = Event ()
self.MouseWheel     = Event ()
self.MouseEnter     = Event ()
self.MouseLeave     = Event ()

self.Click          = Event ()
self.DoubleClick    = Event ()

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
function self:GetRectangle ()
	local x, y = self:GetPosition ()
	local w, h = self:GetSize ()
	return x, y, w, h
end

function self:SetRectangle (x, y, w, h, animation)
	Error ("IView:SetRectangle : Not implemented.")
end

function self:GetPosition ()
	Error ("IView:GetPosition : Not implemented.")
end

function self:SetPosition (x, y, animation)
	Error ("IView:SetPosition : Not implemented.")
end

function self:GetX ()
	local x, _ = self:GetPosition ()
	return x
end

function self:GetY ()
	local _, y = self:GetPosition ()
	return y
end

function self:SetX (x, animation)
	self:SetPosition (x, self:GetY (), animation)
end

function self:SetY (y, animation)
	self:SetPosition (self:GetX (), y, animation)
end

function self:GetSize ()
	Error ("IView:GetSize : Not implemented.")
end

function self:SetSize (w, h, animation)
	Error ("IView:SetSize : Not implemented.")
end

function self:GetWidth ()
	local w, _ = self:GetSize ()
	return w
end

function self:GetHeight ()
	local _, h = self:GetSize ()
	return h
end

function self:SetWidth (w, animation)
	self:SetSize (w, self:GetHeight (), animation)
end

function self:SetHeight (h, animation)
	self:SetSize (self:GetWidth (), h, animation)
end

function self:Center (animation)
	local parentWidth, parentHeight = self:GetParent ():GetSize ()
	local w, h = self:GetSize ()
	self:SetPosition (0.5 * (parentWidth - w), 0.5 * (parentHeight - h), animation)
end

function self:BringToFront ()
	Error ("IView:BringToFront : Not implemented.")
end

function self:SendToBack ()
	Error ("IView:SendToBack : Not implemented.")
end

-- Content layout
function self:GetPreferredSize (maximumWidth, maximumHeight)
	return self:GetSize ()
end

function self:InvalidateLayout ()
	Error ("IView:InvalidateLayout : Not implemented.")
end

-- Children layout
function self:GetContainerPosition ()
	return 0, 0
end

function self:GetContainerSize ()
	return self:GetSize ()
end

function self:GetContainerRectangle ()
	local x, y = self:GetContainerPosition ()
	return x, y, self:GetContainerSize ()
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

function self:GetMousePosition ()
	Error ("IView:GetMousePosition : Not implemented.")
end

function self:CaptureMouse ()
	Error ("IView:CaptureMouse : Not implemented.")
end

function self:ReleaseMouse ()
	Error ("IView:ReleaseMouse : Not implemented.")
end

function self:IsMouseEventConsumer ()
	Error ("IView:IsMouseEventConsumer : Not implemented.")
end

function self:SetConsumesMouseEvents (consumesMouseEvents)
	Error ("IView:SetConsumesMouseEvents : Not implemented.")
end

-- Animations
function self:AddAnimation (animation)
	Error ("IView:AddAnimation : Not implemented.")
end

-- updater (t0, t)
function self:CreateAnimation (updater)
	Error ("IView:CreateAnimation : Not implemented.")
end

-- updater (t)
function self:CreateAnimator (interpolator, duration, updater)
	Error ("IView:CreateAnimator : Not implemented.")
end

-- Internal
function self:OnLayout (contentWidth, contentHeight) end

function self:OnMouseDown (mouseButtons, x, y) end
function self:OnMouseMove (mouseButtons, x, y) end
function self:OnMouseUp   (mouseButtons, x, y) end

function self:OnMouseWheel (delta) end

function self:OnMouseEnter () end
function self:OnMouseLeave () end

function self:OnClick () end
function self:OnDoubleClick () end

function self:OnVisibleChanged (visible) end

function self:Render (w, h, render2d) end
