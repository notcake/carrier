local self = {}
GarrysMod.Window = Class (self, GarrysMod.View, IWindow)

function self:ctor ()
end

-- IWindow
function self:GetTitle ()
	return self:GetPanel ():GetTitle ()
end

function self:SetTitle (title)
	self:GetPanel ():SetTitle (title)
end

-- View
function self:CreatePanel ()
	local panel = vgui.Create ("DFrame")
	panel:SetSizable (true)
	panel:SetDeleteOnClose (false)
	panel:MakePopup ()
	panel:SetKeyboardInputEnabled (false)
	panel:SetVisible (false)
	return panel
end
