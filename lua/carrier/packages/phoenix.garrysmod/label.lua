local self = {}
GarrysMod.Label = Class (self, GarrysMod.View, ILabel)

function self:ctor ()
end

-- ILabel
function self:GetText ()
	return self:GetPanel ():GetText ()
end

function self:SetText (text)
	self:GetPanel ():SetText (text)
end

-- View
function self:CreatePanel ()
	return vgui.Create ("DLabel")
end
