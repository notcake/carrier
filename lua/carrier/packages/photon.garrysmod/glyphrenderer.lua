local self = {}
GlyphRenderer = Class (self)

function self:ctor (graphicsContext, render2d)
	self.GraphicsContext = graphicsContext
	self.Render2d        = render2d
	
	self.Rows = {}
	self.GlyphAllocations = setmetatable ({}, { __mode = "k" })
	
	self.Atlas  = self.GraphicsContext:CreateRenderTarget (1024, 1024, false)
	self.Buffer = self.GraphicsContext:CreateRenderTarget (1024, 1024, false)
	self.AtlasMaterial = CreateMaterial ("Photon.GarrysMod.GlyphRenderer.Atlas", "UnlitGeneric",
		{
			["$translucent"] = 1,
			["$vertexcolor"] = 1,
			["$vertexalpha"] = 1
		}
	)
	self.BufferMaterial = CreateMaterial ("Photon.GarrysMod.GlyphRenderer.Buffer", "UnlitGeneric",
		{
			["$additive"] = 1,
			["$translucent"] = 1,
			["$vertexcolor"] = 1,
			["$vertexalpha"] = 1
		}
	)
	self.AtlasMaterial :SetTexture ("$basetexture", self.Atlas :GetHandle ())
	self.BufferMaterial:SetTexture ("$basetexture", self.Buffer:GetHandle ())
end

function self:dtor ()
	self.Atlas :dtor ()
	self.Buffer:dtor ()
end

-- GlyphRenderer
function self:DrawGlyph (color, glyph, x, y)
	local allocation = self:CacheGlyph (glyph)
	if allocation then
		local cacheX, cacheY = allocation.X, allocation.Y

		surface.SetMaterial (self.AtlasMaterial)
		surface.SetDrawColor (Color.ToRGBA8888 (color))
		
		local du = 0.5 / 32
		local dv = 0.5 / 32
		local u0, v0 = cacheX / self.Atlas:GetWidth (), cacheY / self.Atlas:GetHeight ()
		local u1, v1 = (cacheX + glyph:GetWidth ()) / self.Atlas:GetWidth (), (cacheY + glyph:GetHeight ()) / self.Atlas:GetHeight ()
		local u0, v0 = (u0 - du) / (1 - 2 * du), (v0 - du) / (1 - 2 * dv)
		local u1, v1 = (u1 - du) / (1 - 2 * du), (v1 - du) / (1 - 2 * dv)
		surface.DrawTexturedRectUV (x, y, glyph:GetWidth (), glyph:GetHeight (), u0, v0, u1, v1)
	else
		-- Cannot cache the glyph for some reason,
		-- so draw it directly
		local matrix = Matrix ()
		matrix:Translate (Vector (x, y, 0))
		cam.PushModelMatrix (matrix)
		local success, err = xpcall (glyph.Render, debug.traceback, glyph, self.Render2d, color)
		cam.PopModelMatrix ()
		
		if not success then
			ErrorNoHalt (err)
		end
	end
end

-- Internal
function self:AllocateGlyphRectangle (glyph)
	if glyph:GetWidth  () > self.Atlas:GetWidth  () then return nil end
	if glyph:GetHeight () > self.Atlas:GetHeight () then return nil end
	
	-- Find a row with enough height
	local row = self:FindRow (glyph:GetSize ())
	if not row then
		self:Clear ()
		row = self:FindRow (glyph:GetSize ())
		assert (row)
	end
	
	local x = #row > 0 and (row [#row].X + row [#row].Width) or 0
	local allocation = { X = x, Y = row.Y, Width = glyph:GetWidth (), Height = glyph:GetHeight () }
	row [#row + 1] = allocation
	self.GlyphAllocations [glyph] = allocation
	
	return allocation
end

local dxs = {}
local dys = {}

for y = -1, 1 do
	for x = -1, 1 do
		dxs [#dxs + 1] = x * 1 / 3
		dys [#dys + 1] = y * 1 / 3
	end
end

function self:CacheGlyph (glyph)
	if self.GlyphAllocations [glyph] then return self.GlyphAllocations [glyph] end
	
	local allocation = self:AllocateGlyphRectangle (glyph)
	if not allocation then return nil end
	
	self.GraphicsContext:GetRender3d ():WithRenderTarget (self.Atlas,
		function ()
			cam.Start2D ()
			
			-- Clear out the glyph's rectangle in the atlas with white at alpha 0
			render.SetScissorRect (allocation.X, allocation.Y, allocation.X + glyph:GetWidth (), allocation.Y + glyph:GetHeight (), true)
			render.Clear (255, 255, 255, 0)
			render.SetScissorRect (allocation.X, allocation.Y, allocation.X + glyph:GetWidth (), allocation.Y + glyph:GetHeight (), false)
			
			-- Run the sampler
			for i = 1, #dxs do
				self.GraphicsContext:GetRender3d ():WithRenderTarget (self.Buffer,
					function ()
						render.Clear (0, 0, 0, 0)
						
						cam.Start2D ()
						local matrix = Matrix ()
						matrix:Translate (Vector (dxs [i], dys [i], 0))
						cam.PushModelMatrix (matrix)
						local success, err = xpcall (glyph.Render, debug.traceback, glyph, self.Render2d, Color.White)
						cam.PopModelMatrix ()
						cam.End2D ()
						
						if not success then
							ErrorNoHalt (err)
						end
					end
				)
				
				surface.SetMaterial (self.BufferMaterial)
				surface.SetDrawColor (255, 255, 255, math.ceil (255 / #dxs))
				
				-- Copy the alpha across additively
				local du = 0.5 / 32
				local dv = 0.5 / 32
				local u0, v0 = 0, 0
				local u1, v1 = glyph:GetWidth () / self.Buffer:GetWidth (), glyph:GetHeight () / self.Buffer:GetHeight ()
				local u0, v0 = (u0 - du) / (1 - 2 * du), (v0 - du) / (1 - 2 * dv)
				local u1, v1 = (u1 - du) / (1 - 2 * du), (v1 - du) / (1 - 2 * dv)
				render.OverrideAlphaWriteEnable (true, true)
				render.OverrideColorWriteEnable (true, false)
				surface.DrawTexturedRectUV (allocation.X, allocation.Y, glyph:GetWidth (), glyph:GetHeight (), u0, v0, u1, v1)
				render.OverrideColorWriteEnable (false)
			end
			
			cam.End2D ()
		end
	)
	return allocation
end

function self:Clear ()
	self.Rows = {}
	self.GlyphAllocations = {}
end

function self:FindRow (width, height)
	-- Abort if no row can possibly fit the glyph
	if width  > self.Atlas:GetWidth  () then return nil end
	if height > self.Atlas:GetHeight () then return nil end
	
	for i = 1, #self.Rows do
		local row = self.Rows [i]
		if row.Height >= height then
			if #row == 0 then return row end
			
			if self.Atlas:GetWidth () - row [#row].X - row [#row].Width >= width then
				return row
			end
		end
	end
	
	-- Allocate a new row
	local y = #self.Rows > 0 and (self.Rows [#self.Rows].Y + self.Rows [#self.Rows].Height) or 0
	if y + height > self.Atlas:GetHeight () then return nil end
	
	local row = { Y = y, Height = height }
	self.Rows [#self.Rows + 1] = row
	return row
end
