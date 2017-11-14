-- PACKAGE Pylon.Color.Tests

local Color = require ("Pylon.Color")

return function ()
	local r, g, b, a = Color.ToRGBA8888 (Color.FromRGBA8888 (1, 2, 3, 4))
	
	assert (r == 1)
	assert (g == 2)
	assert (b == 3)
	assert (a == 4)
	
	assert (Color.GetAlpha (Color.WithAlpha (Color.Red, 4)) == 4)
	assert (Color.WithAlpha (Color.Red, 4) == Color.FromRGBA8888 (255, 0, 0, 4))
	
	assert (Color.GetName (Color.Yellow) == "Yellow")
	assert (Color.FromName ("Yellow") == Color.Yellow)
	
	assert (Color.ToHTMLColor (Color.Red) == "red")
	assert (Color.ToHTMLColor (Color.FromRGBA8888 (1, 2, 3, 4)) == "#010203")
	
	assert (Color.FromHTMLColor ("#010203") == Color.FromRGBA8888 (1, 2, 3, 255))
	assert (Color.FromHTMLColor ("#010203", 4) == Color.FromRGBA8888 (1, 2, 3, 4))
	assert (Color.FromHTMLColor ("red", 4) == Color.FromRGBA8888 (255, 0, 0, 4))
end
