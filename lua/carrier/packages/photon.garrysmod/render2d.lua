local self = {}
Render2d = Class (self, Photon.IRender2d)

function self:ctor (graphicsContext)
	self.GraphicsContext = graphicsContext
	
	self.GlyphRenderer = GlyphRenderer (self.GraphicsContext, self)
end

function self:dtor ()
	self.GlyphRenderer:dtor ()
end

-- IRender2d
function self:GetGraphicsContext ()
	return self.GraphicsContext
end

function self:DrawLine (color, x1, y1, x2, y2)
	local x1, y1 = math.floor (x1), math.floor (y1)
	local x2, y2 = math.floor (x2), math.floor (y2)
	
	surface.SetDrawColor (Color.ToRGBA8888 (color))
	surface.DrawLine (x1, y1, x2, y2)
end

function self:DrawRectangle (color, x, y, w, h)
	surface.SetDrawColor (Color.ToRGBA8888 (color))
	surface.DrawOutlinedRect (x, y, w, h)
end

function self:FillRectangle (color, x, y, w, h)
	surface.SetDrawColor (Color.ToRGBA8888 (color))
	surface.DrawRect (x, y, w, h)
end

function self:FillPolygon (color, polygon)
	draw.NoTexture ()
	surface.SetDrawColor (Color.ToRGBA8888 (color))
	
	local t = {}
	for i = 1, polygon:GetPointCount () do
		local x, y = polygon:GetPoint (i)
		t [#t + 1] = { x = x, y = y }
	end
	surface.DrawPoly (t)
end

function self:DrawGlyph (color, glyph, x, y)
	self.GlyphRenderer:DrawGlyph (color, glyph, x, y)
end
