Cat.UnpackedLinearBezier3d = Table.Callable(
	function(x0, y0, z0, x1, y1, z1)
		return x0, y0, z0, x1, y1, z1
	end
)

local UnpackedVector3d_Lerp = Cat.UnpackedVector3d.Lerp
function Cat.UnpackedLinearBezier3d.Position(x0, y0, z0, x1, y1, z1, t)
	return UnpackedVector3d_Lerp(t, x0, y0, z0, x1, y1, z1)
end

function Cat.UnpackedLinearBezier3d.Velocity(x0, y0, z0, x1, y1, z1, t)
	return x1 - x0, y1 - y0, z1 - z0
end

function Cat.UnpackedLinearBezier3d.Acceleration(x0, y0, z0, x1, y1, z1, t)
	return 0, 0, 0
end

local UnpackedVector3d_Length = Cat.UnpackedVector3d.Length
function Cat.UnpackedLinearBezier3d.Distance(x0, y0, z0, x1, y1, z1, t)
	return t * UnpackedVector3d_Length(x1 - x0, y1 - y0, z1 - z0)
end

-- Subdivision
function Cat.UnpackedLinearBezier3d.Subdivide(x0, y0, z0, x1, y1, z1, t)
	local midX, midY, midZ = UnpackedVector3d_Lerp(t, x0, y0, z0, x1, y1, z1)
	return x0, y0, z0, midX, midY, midZ,
	       midX, midY, midZ, x1, y1, z1
end

function Cat.UnpackedLinearBezier3d.SubdivideHalf(x0, y0, z0, x1, y1, z1)
	local midX, midY, midZ = 0.5 * (x0 + x1), 0.5 * (y0 + y1), 0.5 * (z0 + z1)
	return x0, y0, z0, midX, midY, midZ,
	       midX, midY, midZ, x1, y1, z1
end

-- Approximation
function Cat.UnpackedLinearBezier3d.Approximate(x0, y0, z0, x1, y1, z1, callback)
	callback(x0, y0, z0)
	callback(x1, y1, z1)
end

