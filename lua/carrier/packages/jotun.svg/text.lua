local self = {}
Svg.Text = Class (self, Svg.Element)

local defaultFont = Glass.Font ("Times New Roman", 12)

function Svg.Text.FromXmlElement (element)
	local text = Svg.Text ()
	
	text:SetText (element:GetInnerText ())
	
	local x = tonumber (element:GetAttribute ("x")) or 0
	local y = tonumber (element:GetAttribute ("y")) or 0
	text:SetPosition (x, y)
	
	local fontSize = tonumber (element:GetAttribute ("font-size")) or 12
	text:SetFont (text:GetFont ():WithSize (fontSize))
	
	local fill = element:GetAttribute ("fill") or "#000"
	text:SetColor (Color.FromHTMLColor (fill))
	
	local textAnchor = element:GetAttribute ("text-anchor") or "start"
	textAnchor = string.lower (textAnchor)
	
	if textAnchor == "start" then
		text:SetHorizontalAlignment (Glass.HorizontalAlignment.Left)
	elseif textAnchor == "middle" then
		text:SetHorizontalAlignment (Glass.HorizontalAlignment.Center)
	elseif textAnchor == "end" then
		text:SetHorizontalAlignment (Glass.HorizontalAlignment.Right)
	end
	
	return text
end

function self:ctor (x, y, color)
	self.X = x or 0
	self.Y = y or 0
	
	self.Text = ""
	
	self.Font = defaultFont
	
	self.Color = color or Color.Black
	
	self.HorizontalAlignment = Glass.HorizontalAlignment.Left
end

-- Element
function self:Render (render2d, x, y)
	render2d:GetTextRenderer ():DrawTextAligned (self.Text, self.Font, self.Color, self.X + x, self.Y + y, self.HorizontalAlignment, Glass.VerticalAlignment.Bottom)
end

-- Text
function self:GetPosition ()
	return self.X, self.Y
end

function self:GetX ()
	return self.X
end

function self:GetY ()
	return self.Y
end

function self:SetPosition (x, y)
	self.X = x
	self.Y = y
end

function self:SetX (x)
	self.X = x
end

function self:SetY (y)
	self.Y = y
end

function self:GetText ()
	return self.Text
end

function self:SetText (text)
	self.Text = text
end

function self:GetFont ()
	return self.Font
end

function self:SetFont (font)
	self.Font = font
end

function self:GetColor ()
	return self.Color
end

function self:SetColor (color)
	self.Color = color
end

function self:GetHorizontalAlignment ()
	return self.HorizontalAlignment
end

function self:SetHorizontalAlignment (horizontalAlignment)
	self.HorizontalAlignment = horizontalAlignment
end
