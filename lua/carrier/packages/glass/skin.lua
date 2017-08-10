local self = {}
Glass.Skin = Class (self, Glass.ISkin)

function self:ctor ()
	self.Fonts = {}
	self.Fonts [Glass.TextClass.Default]  = Glass.Font ("Roboto", 15)
	self.Fonts [Glass.TextClass.Body]     = Glass.Font ("Roboto", 15)
	self.Fonts [Glass.TextClass.Caption]  = Glass.Font ("Roboto", 13)
	self.Fonts [Glass.TextClass.Headline] = Glass.Font ("Roboto", 15, Glass.FontWeight.Heavy)
	self.Fonts [Glass.TextClass.Title]    = Glass.Font ("Roboto", 26)
end

-- Colors
function self:GetBackgroundColor ()
	return Color.WhiteSmoke
end

function self:GetTextColor ()
	return Color.Black
end

-- Fonts
function self:GetFont (textClass)
	return self.Fonts [textClass]
end

function self:GetDefaultFont ()
	return self.Fonts [Glass.TextClass.Default]
end

function self:GetBodyFont ()
	return self.Fonts [Glass.TextClass.Body]
end

function self:GetCaptionFont ()
	return self.Fonts [Glass.TextClass.Caption]
end

function self:GetHeadlineFont ()
	return self.Fonts [Glass.TextClass.Headline]
end

function self:GetTitleFont ()
	return self.Fonts [Glass.TextClass.Title]
end

-- Metrics
function self:GetScrollbarThickness ()
	return 16
end
