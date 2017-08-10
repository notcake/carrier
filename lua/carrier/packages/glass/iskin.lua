local self = {}
Glass.ISkin = Interface (self)

function self:ctor ()
end

-- Colors
function self:GetBackgroundColor ()
	Error ("ISkin:GetBackgroundColor : Not implemented.")
end

function self:GetTextColor ()
	Error ("ISkin:GetTextColor : Not implemented.")
end

-- Fonts
function self:GetFont (textClass)
	Error ("ISkin:GetFont : Not implemented.")
end

function self:GetDefaultFont ()
	Error ("ISkin:GetDefaultFont : Not implemented.")
end

function self:GetBodyFont ()
	Error ("ISkin:GetBodyFont : Not implemented.")
end

function self:GetCaptionFont ()
	Error ("ISkin:GetCaptionFont : Not implemented.")
end

function self:GetHeadlineFont ()
	Error ("ISkin:GetHeadlineFont : Not implemented.")
end

function self:GetTitleFont ()
	Error ("ISkin:GetTitleFont : Not implemented.")
end

-- Metrics
function self:GetScrollbarThickness ()
	Error ("ISkin:GetScrollbarThickness : Not implemented.")
end
