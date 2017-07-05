local math_floor = math.floor

Color.RGBA8888 = {}

function Color.RGBA8888.FromRGB (r, g, b)
	return Color.RGBA8888.FromRGBA (r, g, b, 1)
end

function Color.RGBA8888.FromRGBA (r, g, b, a)
	return math.floor (r * 255 + 0.5),
	       math.floor (g * 255 + 0.5),
	       math.floor (b * 255 + 0.5),
	       math.floor (a * 255 + 0.5)
end

function Color.RGBA8888.FromPackedRGB888 (rgb, a)
	return math_floor (rgb / 0x00010000) % 256,
	       math_floor (rgb / 0x00000100) % 256,
	                   rgb               % 256,
	       a
end

function Color.RGBA8888.FromPackedARGB888 (argb)
	return math_floor (rgb / 0x00010000) % 256,
	       math_floor (rgb / 0x00000100) % 256,
	                   rgb               % 256,
	       math_floor (color / 0x01000000)
end

function Color.RGBA8888.FromRGB888 (r, g, b)
	return r, g, b, 255
end

function Color.RGBA8888.FromRGBA8888 (r, g, b, a)
	return r, g, b, a
end

function Color.RGBA8888.ToRGBA (r, g, b, a)
	return r / 255, g / 255, b / 255, a / 255
end

function Color.RGBA8888.ToPackedRGB888 (r, g, b, a)
	return r * 0x00010000 +
	       g * 0x00000100 +
	       b * 0x00000001,
	       a
end

function Color.RGBA8888.ToPackedARGB8888 (r, g, b, a)
	return a * 0x01000000 +
	       r * 0x00010000 +
	       g * 0x00000100 +
	       b * 0x00000001
end

function Color.RGBA8888.ToRGB888 (r, g, b, a)
	return Color.ToRGBA8888 (r, g, b, a)
end

function Color.RGBA8888.ToRGBA8888 (r, g, b, a)
	return r, g, b, a
end

function Color.RGBA8888.GetAlpha (r, g, b, a)
	return a
end

function Color.RGBA8888.WithAlpha (r, g, b, _, a)
	return r, g, b, a
end

function Color.RGBA8888.Lerp (t, r0, g0, b0, a0, r1, g1, b1, a1)
	return t * r1 + (1 - t) * r0,
	       t * g1 + (1 - t) * g0,
	       t * b1 + (1 - t) * b0,
	       t * a1 + (1 - t) * a0
end

function Color.RGBA8888.FromName (colorName)
	local color = Color.PackedARGB8888.FromName (colorName)
	if not color then return nil end
	return Color.RGBA8888.FromPackedARGB888 (color)
end

function Color.RGBA8888.GetName (r, g, b, a)
	return Color.PackedARGB8888.GetName (Color.RGBA8888.ToPackedARGB8888 (r, g, b, a))
end

function Color.RGBA8888.FromHTMLColor (color, a)
	return Color.RGBA8888.FromPackedARGB888 (Color.PackedARGB8888.FromHTMLColor (color, a))
end

function Color.RGBA8888.ToHTMLColor (r, g, b, a)
	return Color.PackedARGB8888.ToHTMLColor (Color.RGBA8888.ToPackedARGB8888 (r, g, b, a))
end
