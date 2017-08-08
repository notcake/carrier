local self = {}
GarrysMod.Window.RestoreButton = Class (self, GarrysMod.View)

function self:ctor ()
	self:SetConsumesMouseEvents (true)
end

-- IView
-- Internal
function self:Render (w, h, render2d)
	if not self:GetHandle ().m_bBackground then return end

	if self:GetHandle ():GetDisabled () then
		return self:GetHandle ():GetSkin ().tex.Window.Restore (0, 0, w, h, Color (255, 255, 255, 50))
	end	

	if self:GetHandle ().Depressed or self:GetHandle ():IsSelected () then
		return self:GetHandle ():GetSkin ().tex.Window.Restore_Down (0, 0, w, h)
	end	

	if self:GetHandle ().Hovered then
		return self:GetHandle ():GetSkin ().tex.Window.Restore_Hover (0, 0, w, h)
	end

	self:GetHandle ():GetSkin ().tex.Window.Restore (0, 0, w, h)
end

-- View
function self:CreatePanel ()
	local panel = vgui.Create ("DButton")
	panel:SetText ("")
	return panel
end
