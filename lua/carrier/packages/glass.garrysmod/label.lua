local self = {}
GarrysMod.Label = Class (self, GarrysMod.View, ILabel)

function self:ctor ()
end

-- IView
-- Content layout
function self:GetPreferredSize (maximumWidth, maximumHeight)
	return self:GetPanel ():GetContentSize ()
end

-- ILabel
function self:GetFont ()
	return self.Font
end

function self:SetFont (font)
	self.Font = font
	self:GetPanel ():SetFont (font:GetId ())
end

function self:GetText ()
	return self:GetPanel ():GetText ()
end

function self:SetText (text)
	self:GetPanel ():SetText (text)
end

function self:GetTextColor ()
	local color = self:GetPanel ():GetTextColor ()
	return Color.FromRGBA8888 (color.r, color.g, color.b, color.a)
end

function self:SetTextColor (color)
	self:GetPanel ():SetTextColor (_G.Color (Color.ToRGBA8888 (color)))
end

-- View
function self:CreatePanel ()
	local label = vgui.Create ("DLabel")
	label:SetFont (GarrysMod.Skin.Default.Fonts.Default:GetId ())
	label:SetTextColor (_G.Color (Color.ToRGBA8888 (GarrysMod.Skin.Default.Colors.Text)))
	return label
end
