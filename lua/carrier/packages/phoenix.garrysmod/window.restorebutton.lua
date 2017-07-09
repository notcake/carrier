local self = {}
GarrysMod.Window.RestoreButton = Class (self, GarrysMod.View)

function self:ctor ()
end

-- IView
-- Internal
function self:Render (w, h, render2d)
	if not self:GetPanel ().m_bBackground then return end

	if self:GetPanel ():GetDisabled () then
		return self:GetPanel ():GetSkin ().tex.Window.Restore (0, 0, w, h, Color (255, 255, 255, 50))
	end	

	if self:GetPanel ().Depressed or self:GetPanel ():IsSelected () then
		return self:GetPanel ():GetSkin ().tex.Window.Restore_Down (0, 0, w, h)
	end	

	if self:GetPanel ().Hovered then
		return self:GetPanel ():GetSkin ().tex.Window.Restore_Hover (0, 0, w, h)
	end

	self:GetPanel ():GetSkin ().tex.Window.Restore (0, 0, w, h)
end

-- View
function self:CreatePanel ()
	local panel = vgui.Create ("DButton")
	panel:SetText ("")
	return panel
end
