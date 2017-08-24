Cat.UnpackedLinearBezier2d = Table.Callable (
	function (x0, y0, x1, y1)
		return x0, y0, x1, y1
	end
)

local UnpackedVector2d_Lerp = Cat.UnpackedVector2d.Lerp
function Cat.UnpackedLinearBezier2d.Position (x0, y0, x1, y1, t)
	return UnpackedVector2d_Lerp (t, x0, y0, x1, y1)
end

function Cat.UnpackedLinearBezier2d.Velocity (x0, y0, x1, y1, t)
	return x1 - x0, y1 - y0
end

function Cat.UnpackedLinearBezier2d.Acceleration (x0, y0, x1, y1, t)
	return 0, 0
end

local UnpackedVector2d_Length = Cat.UnpackedVector2d.Length
function Cat.UnpackedLinearBezier2d.Distance (x0, y0, x1, y1, t)
	return t * UnpackedVector2d_Length (x1 - x0, y1 - y0)
end

-- Subdivision
function Cat.UnpackedLinearBezier2d.Subdivide (x0, y0, x1, y1, t)
	local midX, midY = UnpackedVector2d_Lerp (t, x0, y0, x1, y1)
	return x0, y0, midX, midY,
	       midX, midY, x1, y1
end

function Cat.UnpackedLinearBezier2d.SubdivideHalf (x0, y0, x1, y1)
	local midX, midY = 0.5 * (x0 + x1), 0.5 * (y0 + y1)
	return x0, y0, midX, midY,
	       midX, midY, x1, y1
end

-- Approximation
function Cat.UnpackedLinearBezier2d.Approximate (x0, y0, x1, y1, callback)
	callback (x0, y0)
	callback (x1, y1)
end
