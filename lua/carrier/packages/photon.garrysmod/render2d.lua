local self = {}
Render2d = Class (self, Photon.IRender2d)

function self:ctor (graphicsContext)
	self.GraphicsContext = graphicsContext
	
	self.GlyphRenderer = GlyphRenderer (self.GraphicsContext, self)
	
	self.ConvexPolygonBuffer = PolygonBuffer ()
	self.EvenOddPolygonBuffers = {}
end

function self:dtor ()
	self.GlyphRenderer:dtor ()
end

-- IRender2d
function self:GetGraphicsContext ()
	return self.GraphicsContext
end

function self:GetTextRenderer ()
	return self.GraphicsContext:GetTextRenderer ()
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

function self:FillConvexPolygon (color, polygon)
	draw.NoTexture ()
	surface.SetDrawColor (Color.ToRGBA8888 (color))
	
	self.ConvexPolygonBuffer:Bind (polygon)
	surface.DrawPoly (self.ConvexPolygonBuffer:GetBuffer ())
	self.ConvexPolygonBuffer:Unbind ()
end

function self:FillPolygonEvenOdd (color, polygons, boundingX, boundingY, boundingW, boundingH)
	local boundingX = boundingX or 0
	local boundingY = boundingY or 0
	local boundingW = boundingW or ScrW ()
	local boundingH = boundingH or ScrH ()
	
	draw.NoTexture ()
	
	-- Resize
	for i = #self.EvenOddPolygonBuffers + 1, #polygons do
		self.EvenOddPolygonBuffers [i] = PolygonBuffer ()
	end
	
	-- Bind
	for i = 1, #polygons do
		self.EvenOddPolygonBuffers [i]:Bind (polygons [i])
	end
	
	render.SetStencilEnable (true)
	render.SetStencilWriteMask (0xFF)
	render.ClearStencil ()
	render.SetStencilCompareFunction (STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilFailOperation (STENCILOPERATION_INVERT)
	
	-- Note: Backface culling doesn't happen with stencils!
	for i = 1, #polygons do
		render.CullMode(MATERIAL_CULLMODE_CW)
		surface.DrawPoly (self.EvenOddPolygonBuffers [i]:GetBuffer ())
		render.CullMode(MATERIAL_CULLMODE_CCW)
		surface.DrawPoly (self.EvenOddPolygonBuffers [i]:GetBuffer ())
	end
	
	-- Unbind
	for i = 1, #polygons do
		self.EvenOddPolygonBuffers [i]:Unbind ()
	end
	
	render.SetStencilTestMask (0x01)
	render.SetStencilReferenceValue (0x01)
	render.SetStencilWriteMask (0x00)
	render.SetStencilCompareFunction (STENCILCOMPARISONFUNCTION_EQUAL)
	
	surface.SetDrawColor (Color.ToRGBA8888 (color))
	surface.DrawRect (boundingX, boundingY, boundingW, boundingH)
	
	render.SetStencilEnable (false)
end

function self:DrawGlyph (color, glyph, x, y)
	self.GlyphRenderer:DrawGlyph (color, glyph, x, y)
end
