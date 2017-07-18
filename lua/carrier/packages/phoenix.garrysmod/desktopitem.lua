local self = {}
DesktopItem = Class (self)

self.Click = Event ()

function self:ctor (desktop, text, icon)
	self.Desktop = desktop
	
	self.Text = text
	self.Icon = icon or "error"
end

function self:dtor ()
	self.Desktop:RemoveItem (self)
end

function self:GetIcon ()
	return self.Icon
end

function self:GetId ()
	return string.format ("Phoenix.GarrysMod.DesktopItem_%p", self)
end

function self:GetText ()
	return self.Text
end

function self:Remove ()
	self:dtor ()
end
