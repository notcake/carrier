Cat.UnpackedQuadraticBezier2d = Table.Callable (
	function (x0, y0, x1, y1, x2, y2)
		return x0, y0, x1, y1, x2, y2
	end
)

local UnpackedVector2d_Lerp = Cat.UnpackedVector2d.Lerp
function Cat.UnpackedQuadraticBezier2d.Position (x0, y0, x1, y1, x2, y2, t)
	local ax0, ay0 = UnpackedVector2d_Lerp (t, x0, y0, x1, y1)
	local ax1, ay1 = UnpackedVector2d_Lerp (t, x1, y1, x2, y2)
	return UnpackedVector2d_Lerp (t, ax0, ay0, ax1, ay1)
end

function Cat.UnpackedQuadraticBezier2d.Velocity (x0, y0, x1, y1, x2, y2, t)
	-- d/dt  Lerp(t, x0, x1) = x1 - x0
	-- d/dx0 Lerp(t, x0, x1) = 1 - t
	-- d/dx1 Lerp(t, x0, x1) = t
	
	-- quadratic: (x, y)  = Lerp(t, Lerp(t, x0, x1), Lerp(t, x1, x2))
	--            (x, y)' = Lerp(t, x1, x2) - Lerp(t, x0, x1) + (1 - t) Lerp(t, x0, x1)' + t Lerp(t, x1, x2)'
	--            (x, y)' = Lerp(t, x1, x2) - Lerp(t, x0, x1) + (1 - t) (x1 - x0) + t (x2 - x1)
	--            (x, y)' = Lerp(t, x1, x2) - Lerp(t, x0, x1) + Lerp(t, x1 - x0, x2 - x1)
	--            (x, y)' = Lerp(t, x1 - x0, x2 - x1) + Lerp(t, x1 - x0, x2 - x1)
	--            (x, y)' = 2 Lerp(t, x1 - x0, x2 - x1)
	local dx0, dy0 = x1 - x0, y1 - y0
	local dx1, dy1 = x2 - x1, y2 - y1
	local dx, dy = UnpackedVector2d_Lerp (t, dx0, dy0, dx1, dy1)
	return 2 * dx, 2 * dy
end

function Cat.UnpackedQuadraticBezier2d.Acceleration (x0, y0, x1, y1, x2, y2, t)
	-- quadratic: (x, y)   = Lerp(t, Lerp(t, x0, x1), Lerp(t, x1, x2))
	--            (x, y)'  = 2 Lerp(t, x1 - x0, x2 - x1)
	--            (x, y)'' = 2 ((x2 - x1) - (x1 - x0))
	--            (x, y)'' = 2 (x2 - 2 x1 + x0)
	return 2 * (x2 - 2 * x1 + x0), 2 * (y2 - 2 * y1 + y0)
end

-- nope.avi
-- function Cat.UnpackedQuadraticBezier2d.Distance (x0, y0, x1, y1, x2, y2, t)
-- end

-- Subdivision
function Cat.UnpackedQuadraticBezier2d.Subdivide (x0, y0, x1, y1, x2, y2, t)
	local ax0, ay0 = UnpackedVector2d_Lerp (t, x0, y0, x1, y1)
	local ax1, ay1 = UnpackedVector2d_Lerp (t, x1, y1, x2, y2)
	local midX, midY = UnpackedVector2d_Lerp (t, ax0, ay0, ax1, ay1)
	return x0, y0, ax0, ay0, midX, midY,
	       midX, midY, ax1, ay1, x2, y2
end

function Cat.UnpackedQuadraticBezier2d.SubdivideHalf (x0, y0, x1, y1, x2, y2)
	local ax0, ay0 = 0.5 * (x0 + x1), 0.5 * (y0 + y1)
	local ax1, ay1 = 0.5 * (x1 + x2), 0.5 * (y1 + y2)
	
	local midX, midY = 0.5 * (ax0 + ax1), 0.5 * (ay0 + ay1)
	return x0, y0, ax0, ay0, midX, midY,
	       midX, midY, ax1, ay1, x2, y2
end

-- Approximation
local UnpackedVector2d_LengthSquared = Cat.UnpackedVector2d.LengthSquared
local UnpackedQuadraticBezier2d_SubdivideHalf = Cat.UnpackedQuadraticBezier2d.SubdivideHalf
local function UnpackedQuadraticBezier2d_ApproximateTail (x0, y0, x1, y1, x2, y2, maximumSpacingSquared, callback)
	if UnpackedVector2d_LengthSquared (x1 - x0, y1 - y0) +
	   UnpackedVector2d_LengthSquared (x2 - x1, y2 - y1) > maximumSpacingSquared then
		local _, _, cx0, cy0, midX, midY,
			  _, _, cx1, cy1, _, _ = UnpackedQuadraticBezier2d_SubdivideHalf (x0, y0, x1, y1, x2, y2)
		UnpackedQuadraticBezier2d_ApproximateTail (x0, y0, cx0, cy0, midX, midY, maximumSpacingSquared, callback)
		UnpackedQuadraticBezier2d_ApproximateTail (midX, midY, cx1, cy1, x2, y2, maximumSpacingSquared, callback)
	else
		callback (x2, y2)
	end
end

function Cat.UnpackedQuadraticBezier2d.Approximate (x0, y0, x1, y1, x2, y2, maximumSpacing, callback)
	callback (x0, y0)
	
	UnpackedQuadraticBezier2d_ApproximateTail (x0, y0, x1, y1, x2, y2, maximumSpacing * maximumSpacing, callback)
end
