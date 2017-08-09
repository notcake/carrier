local self = {}
GarrysMod.Window.RestoreButton = Class (self, GarrysMod.View)

function self:ctor ()
	self.ButtonBehaviour = Glass.ButtonBehaviour (self)
	
	self:SetCursor (Glass.Cursor.Hand)
	
	self:SetConsumesMouseEvents (true)
end

-- IView
-- Internal
function self:Render (w, h, render2d)
	if self.ButtonBehaviour:IsPressed () or self.ButtonBehaviour:IsMouseCaptured () then
		return self:GetHandle ():GetSkin ().tex.Window.Restore_Down (0, 0, w, h)
	end	
	
	if self.ButtonBehaviour:IsHovered () then
		return self:GetHandle ():GetSkin ().tex.Window.Restore_Hover (0, 0, w, h)
	end
	
	self:GetHandle ():GetSkin ().tex.Window.Restore (0, 0, w, h)
end
