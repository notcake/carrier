local self = {}
Svg.Polygon = Class (self, Svg.Element)

function Svg.Polygon.FromXmlElement (xmlElement)
	local polygon = Svg.Polygon ()
	
	local fill = xmlElement:GetAttribute ("fill") or "#000"
	polygon:SetFillColor (string.lower (fill) ~= "none" and Color.FromHTMLColor (fill) or nil)
	
	local stroke = xmlElement:GetAttribute ("stroke") or "none"
	polygon:SetStrokeColor (string.lower (stroke) ~= "none" and Color.FromHTMLColor (stroke) or nil)
	
	local points = xmlElement:GetAttribute ("points") or ""
	local parser = PathParser (points)
	
	parser:AcceptWhitespace ()
	while not parser:IsEndOfInput () do
		local x, y = parser:AcceptOptionalCoordinatePair ()
		if not x then break end
		
		polygon.Polygon:AddPoint (x, y)
		parser:AcceptCommaWhitespace ()
	end
	
	return polygon
end

function self:ctor ()
	self.StrokeColor = nil
	self.FillColor   = Color.Black
	
	self.Polygon     = Photon.Polygon ()
end

-- Element
-- Internal
function self:RenderContents (render2d, resolution)
	render2d:FillPolygonEvenOdd (self.FillColor, self.Polygon)
end

-- Polygon
function self:GetFillColor ()
	return self.FillColor
end

function self:GetStrokeColor ()
	return self.StrokeColor
end

function self:SetFillColor (fillColor)
	self.FillColor = fillColor
end

function self:SetStrokeColor (strokeColor)
	self.StrokeColor = strokeColor
end
