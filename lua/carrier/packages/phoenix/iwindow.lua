local self = {}
Phoenix.IWindow = Interface (self, Phoenix.IView)

function self:ctor ()
end

function self:GetTitle ()
	Error ("IWindow:GetTitle : Not implemented.")
end

function self:SetTitle (title)
	Error ("IWindow:SetTitle : Not implemented.")
end
