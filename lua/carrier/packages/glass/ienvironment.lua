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

function self:CreateView ()
	Error ("IEnvironment:CreateView : Not implemented.")
end

-- Hierarchy
function self:GetParent (view, handle)
	Error ("IEnvironment:GetParent : Not implemented.")
end

function self:SetParent (view, handle, parentHandle)
	Error ("IEnvironment:SetParent : Not implemented.")
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
function self:BringToFront (view, handle)
	Error ("IEnvironment:BringToFront : Not implemented.")
end

function self:MoveToBack (view, handle)
	Error ("IEnvironment:MoveToBack : Not implemented.")
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
