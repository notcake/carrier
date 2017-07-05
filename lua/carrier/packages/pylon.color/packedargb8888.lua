local math_floor = math.floor

Color.PackedARGB8888 = {}

function Color.PackedARGB8888.FromRGB (r, g, b)
	return Color.PackedARGB8888.FromRGBA (r, g, b, 1)
end

function Color.PackedARGB8888.FromRGBA (r, g, b, a)
	return Color.PackedARGB8888.FromRGBA8888 (
		math.floor (r * 255 + 0.5),
		math.floor (g * 255 + 0.5),
		math.floor (b * 255 + 0.5),
		math.floor (a * 255 + 0.5)
	)
end

function Color.PackedARGB8888.FromPackedRGB888 (rgb, a)
	local a = a or 255
	return a * 0x01000000 + rgb
end

function Color.PackedARGB8888.FromPackedARGB8888 (argb)
	return argb
end

function Color.PackedARGB8888.FromRGB888 (r, g, b)
	return Color.PackedARGB8888.FromRGBA8888 (r, g, b, 255)
end

function Color.PackedARGB8888.FromRGBA8888 (r, g, b, a)
	return a * 0x01000000 +
	       r * 0x00010000 +
	       g * 0x00000100 +
	       b * 0x00000001
end

function Color.PackedARGB8888.ToRGB (color)
	return Color.PackedARGB8888.ToRGBA (color)
end

function Color.PackedARGB8888.ToRGBA (color)
	local r, g, b, a = Color.PackedARGB8888.ToRGBA8888 (color)
	return r / 255, g / 255, b / 255, a / 255
end

function Color.PackedARGB8888.ToPackedRGB888 (color)
	return color % 0x01000000, math_floor (color / 0x01000000)
end

function Color.PackedARGB8888.ToPackedARGB8888 (color)
	return color
end

function Color.PackedARGB8888.ToRGB888 (color)
	return Color.PackedARGB8888.ToRGBA8888 (color)
end

function Color.PackedARGB8888.ToRGBA8888 (color)
	return math_floor (color / 0x00010000) % 256,
	       math_floor (color / 0x00000100) % 256,
	                   color               % 256,
	       math_floor (color / 0x01000000)
end

function Color.PackedARGB8888.GetAlpha (color)
	return math_floor (color / 0x01000000)
end

function Color.PackedARGB8888.WithAlpha (color, a)
	return a * 0x01000000 + color % 0x01000000
end

function Color.PackedARGB8888.Lerp (t, color0, color1)
	local r0, g0, b0, a0 = Color.PackedARGB8888.ToRGBA8888 (color0)
	local r1, g1, b1, a1 = Color.PackedARGB8888.ToRGBA8888 (color1)
	return Color.PackedARGB8888.FromRGBA8888 (Color.RGBA8888.Lerp (t, r0, g0, b0, a0, r1, g1, b1, a1))
end

WebColors.Initialize (Color.PackedARGB8888, Color.PackedARGB8888.FromRGBA8888)

function Color.PackedARGB8888.FromHTMLColor (color, a)
	local namedColor = Color.PackedARGB8888.FromName (color)
	if namedColor then
		return a == nil and namedColor or Color.PackedARGB8888.WithAlpha (namedColor, a)
	else
		-- #RRGGBB
		if string.sub (color, 1, 1) == "#" then
			color = string.sub (color, 2)
		end
		return Color.PackedARGB8888.FromPackedRGB888 (tonumber (color, 16), a or 255)
	end
end

function Color.PackedARGB8888.ToHTMLColor (color)
	local name = Color.PackedARGB8888.GetName (color)
	if name then return string.lower (name) end
	
	return string.format ("#%06X", Color.PackedARGB8888.ToPackedRGB888 (color))
end
