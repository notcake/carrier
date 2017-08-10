local self = {}
Glass.IEnvironment = Interface (self)

function self:ctor ()
end

function self:GetGraphicsContext ()
	Error ("IEnvironment:GetGraphicsContext : Not implemented.")
end

function self:GetTextRenderer ()
	Error ("IEnvironment:GetTextRenderer : Not implemented.")
end

function self:GetRootView ()
	Error ("IEnvironment:GetRootView : Not implemented.")
end

function self:CreateHandle (view, parentHandle)
	Error ("IEnvironment:CreateHandle : Not implemented.")
end

function self:CreateWindowHandle (view, parentHandle)
	Error ("IEnvironment:CreateWindowHandle : Not implemented.")
end

function self:CreateLabelHandle (view, parentHandle)
	Error ("IEnvironment:CreateLabelHandle : Not implemented.")
end

function self:DestroyHandle (view, handle)
	Error ("IEnvironment:DestroyHandle : Not implemented.")
end

-- View
-- Hierarchy
function self:GetParent (view, handle)
	Error ("IEnvironment:GetParent : Not implemented.")
end

function self:SetParent (view, handle, parentHandle)
	Error ("IEnvironment:SetParent : Not implemented.")
end

function self:BringChildToFront (view, handle, childHandle)
	Error ("IEnvironment:BringChildToFront : Not implemented.")
end

function self:SendChildToBack (view, handle, childHandle)
	Error ("IEnvironment:SendChildToBack : Not implemented.")
end

-- Bounds
function self:GetRectangle (view, handle)
	Error ("IEnvironment:GetRectangle : Not implemented.")
end

function self:GetPosition (view, handle)
	Error ("IEnvironment:GetPosition : Not implemented.")
end

function self:GetSize (view, handle)
	Error ("IEnvironment:GetSize : Not implemented.")
end

function self:SetRectangle (view, handle, x, y, w, h)
	Error ("IEnvironment:SetRectangle : Not implemented.")
end

function self:SetPosition (view, handle, x, y)
	Error ("IEnvironment:SetPosition : Not implemented.")
end

function self:SetSize (view, handle, w, h)
	Error ("IEnvironment:SetSize : Not implemented.")
end

-- Layout
function self:InvalidateLayout (view, handle)
	Error ("IEnvironment:InvalidateLayout : Not implemented.")
end

-- Appearance
function self:IsVisible (view, handle)
	Error ("IEnvironment:IsVisible : Not implemented.")
end

function self:SetVisible (view, handle)
	Error ("IEnvironment:SetVisible : Not implemented.")
end

-- Mouse
function self:GetCursor (view, handle)
	Error ("IEnvironment:GetCursor : Not implemented.")
end

function self:SetCursor (view, handle, cursor)
	Error ("IEnvironment:SetCursor : Not implemented.")
end

function self:GetMousePosition (view, handle)
	Error ("IEnvironment:GetMousePosition : Not implemented.")
end

function self:CaptureMouse (view, handle)
	Error ("IEnvironment:CaptureMouse : Not implemented.")
end

function self:ReleaseMouse (view, handle)
	Error ("IEnvironment:ReleaseMouse : Not implemented.")
end

-- Animations
function self:AddAnimation (view, handle, animation)
	Error ("IEnvironment:AddAnimation : Not implemented.")
end

function self:RemoveAnimation (view, handle, animation)
	Error ("IEnvironment:RemoveAnimation : Not implemented.")
end

-- Label
function self:GetLabelText (view, handle)
	Error ("IEnvironment:GetLabelText : Not implemented.")
end

function self:GetLabelFont (view, handle)
	Error ("IEnvironment:GetLabelFont : Not implemented.")
end

function self:GetLabelTextColor (view, handle)
	Error ("IEnvironment:GetLabelTextColor : Not implemented.")
end

function self:GetHorizontalAlignment (view, handle)
	Error ("IEnvironment:GetHorizontalAlignment : Not implemented.")
end

function self:GetVerticalAlignment (view, handle)
	Error ("IEnvironment:GetVerticalAlignment : Not implemented.")
end

function self:SetLabelText (view, handle, text)
	Error ("IEnvironment:SetLabelText : Not implemented.")
end

function self:SetLabelFont (view, handle, font)
	Error ("IEnvironment:SetLabelFont : Not implemented.")
end

function self:SetLabelTextColor (view, handle, textColor)
	Error ("IEnvironment:SetLabelTextColor : Not implemented.")
end

function self:SetHorizontalAlignment (view, handle, horizontalAlignment)
	Error ("IEnvironment:SetHorizontalAlignment : Not implemented.")
end

function self:SetVerticalAlignment (view, handle, verticalAlignment)
	Error ("IEnvironment:SetVerticalAlignment : Not implemented.")
end
