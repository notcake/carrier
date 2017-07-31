local self = {}
GarrysMod.Window.RestoreButton = Class (self, GarrysMod.View)

function self:ctor ()
	self.MouseDown  :AddListener ("Glass.GarrysMod.Window.RestoreButton." .. self:GetHashCode (), self, self.SuppressBubbling)
	self.MouseMove  :AddListener ("Glass.GarrysMod.Window.RestoreButton." .. self:GetHashCode (), self, self.SuppressBubbling)
	self.MouseUp    :AddListener ("Glass.GarrysMod.Window.RestoreButton." .. self:GetHashCode (), self, self.SuppressBubbling)
	self.Click      :AddListener ("Glass.GarrysMod.Window.RestoreButton." .. self:GetHashCode (), self, self.SuppressBubbling)
	self.DoubleClick:AddListener ("Glass.GarrysMod.Window.RestoreButton." .. self:GetHashCode (), self, self.SuppressBubbling)
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

-- Internal
function self:SuppressBubbling ()
	return true
end
