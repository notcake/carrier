local self = {}
GarrysMod.Label = Class (self, GarrysMod.View, ILabel)

function self:ctor ()
	self.Font = GarrysMod.Skin.Default.Fonts.Default
	self.HorizontalAlignment = Glass.HorizontalAlignment.Left
	self.VerticalAlignment   = Glass.VerticalAlignment.Center
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

function self:GetHorizontalAlignment ()
	return self.HorizontalAlignment
end

function self:GetVerticalAlignment ()
	return self.VerticalAlignment
end

function self:SetHorizontalAlignment (horizontalAlignment)
	self.HorizontalAlignment = horizontalAlignment
	
	self:UpdateAlignment (self:GetPanel ())
end

function self:SetVerticalAlignment (verticalAlignment)
	self.VerticalAlignment = verticalAlignment
	
	self:UpdateAlignment (self:GetPanel ())
end

-- View
function self:CreatePanel ()
	local label = vgui.Create ("DLabel")
	label:SetFont (self.Font:GetId ())
	label:SetTextColor (_G.Color (Color.ToRGBA8888 (GarrysMod.Skin.Default.Colors.Text)))
	self:UpdateAlignment (label)
	return label
end

-- Label
-- Internal
function self:UpdateAlignment (label)
	label:SetContentAlignment (ContentAlignment.FromAlignment (self.HorizontalAlignment, self.VerticalAlignment))
	
	if self.HorizontalAlignment == Glass.HorizontalAlignment.Right then
		label:SetTextInset (1, 0)
	else
		label:SetTextInset (0, 0)
	end
end
