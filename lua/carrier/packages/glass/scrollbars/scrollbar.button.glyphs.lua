Scrollbar.Button.Polygons = {}
Scrollbar.Button.Glyphs   = {}

Scrollbar.Button.Polygons.Up = Photon.Polygon()
Scrollbar.Button.Polygons.Up:AddPoint( 8,  5)
Scrollbar.Button.Polygons.Up:AddPoint(12, 10)
Scrollbar.Button.Polygons.Up:AddPoint( 4, 10)

Scrollbar.Button.Polygons.Right = Scrollbar.Button.Polygons.Up:Clone()
Scrollbar.Button.Polygons.Right:Rotate(math.rad(90), 8, 8)

Scrollbar.Button.Polygons.Left = Scrollbar.Button.Polygons.Up:Clone()
Scrollbar.Button.Polygons.Left:Rotate(math.rad(-90), 8, 8)

Scrollbar.Button.Polygons.Down = Scrollbar.Button.Polygons.Up:Clone()
Scrollbar.Button.Polygons.Down:Rotate(math.rad(180), 8, 8)

for name, polygon in pairs(Scrollbar.Button.Polygons) do
	Scrollbar.Button.Glyphs[name] = Photon.Glyph(16, 16,
		function(render2d, color)
			render2d:FillConvexPolygon(color, polygon)
		end
	)
end
