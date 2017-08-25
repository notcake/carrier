Cat.UnpackedCubicBezier2d = Table.Callable (
	function (x0, y0, x1, y1, x2, y2, x3, y3)
		return x0, y0, x1, y1, x2, y2, x3, y3
	end
)

local UnpackedVector2d_Lerp = Cat.UnpackedVector2d.Lerp
function Cat.UnpackedCubicBezier2d.Position (x0, y0, x1, y1, x2, y2, x3, y3, t)
	local ax0, ay0 = UnpackedVector2d_Lerp (t, x0, y0, x1, y1)
	local ax1, ay1 = UnpackedVector2d_Lerp (t, x1, y1, x2, y2)
	local ax2, ay2 = UnpackedVector2d_Lerp (t, x2, y2, x3, y3)
	
	local bx0, by0 = UnpackedVector2d_Lerp (t, ax0, ay0, ax1, ay1)
	local bx1, by1 = UnpackedVector2d_Lerp (t, ax1, ay1, ax2, ay2)
	
	return UnpackedVector2d_Lerp (t, bx0, by0, bx1, by1)
end

function Cat.UnpackedCubicBezier2d.Velocity (x0, y0, x1, y1, x2, y2, x3, y3, t)
	-- quadratic: (x, y)  = Lerp(t, Lerp(t, x0, x1), Lerp(t, x1, x2))
	--            (x, y)' = Lerp(t, x1, x2) - Lerp(t, x0, x1) + (1 - t) Lerp(t, x0, x1)' + t Lerp(t, x1, x2)'
	--            (x, y)' = Lerp(t, x1, x2) - Lerp(t, x0, x1) + (1 - t) (x1 - x0) + t (x2 - x1)
	--            (x, y)' = Lerp(t, x1, x2) - Lerp(t, x0, x1) + Lerp(t, x1 - x0, x2 - x1)
	--            (x, y)' = Lerp(t, x1 - x0, x2 - x1) + Lerp(t, x1 - x0, x2 - x1)
	--            (x, y)' = 2 Lerp(t, x1 - x0, x2 - x1)
	-- cubic:     (x, y)  = Lerp(t, Lerp(t, Lerp(t, x0, x1), Lerp(t, x1, x2)), Lerp(t, Lerp(t, x1, x2), Lerp(t, x2, x3)))
	--            (x, y)' = Lerp(t, Lerp(t, x1, x2), Lerp(t, x2, x3)) - Lerp(t, Lerp(t, x0, x1), Lerp(t, x1, x2)) +
	--                      (1 - t) Lerp(t, Lerp(t, x0, x1), Lerp(t, x1, x2))' +
	--                           t  Lerp(t, Lerp(t, x1, x2), Lerp(t, x2, x3))'
	--            (x, y)' = Lerp(t, Lerp(t, x1, x2), Lerp(t, x2, x3)) - Lerp(t, Lerp(t, x0, x1), Lerp(t, x1, x2)) +
	--                      (1 - t) (Lerp(t, x1, x2) - Lerp(t, x0, x1) + (1 - t) (x1 - x0) + t (x2 - x1)) +
	--                           t  (Lerp(t, x2, x3) - Lerp(t, x1, x2) + (1 - t) (x2 - x1) + t (x3 - x2))
	--            (x, y)' = Lerp(t, Lerp(t, x1, x2), Lerp(t, x2, x3)) - Lerp(t, Lerp(t, x0, x1), Lerp(t, x1, x2)) +
	--                      (1 - t) (Lerp(t, x1, x2) - Lerp(t, x0, x1) + Lerp(t, x1 - x0, x2 - x1)) +
	--                           t  (Lerp(t, x2, x3) - Lerp(t, x1, x2) + Lerp(t, x2 - x1, x3 - x2))
	--            (x, y)' = Lerp(t, Lerp(t, x1, x2), Lerp(t, x2, x3)) - Lerp(t, Lerp(t, x0, x1), Lerp(t, x1, x2)) +
	--                      (1 - t) (Lerp(t, x1 - x0, x2 - x1) + Lerp(t, x1 - x0, x2 - x1)) +
	--                           t  (Lerp(t, x2 - x1, x3 - x2) + Lerp(t, x2 - x1, x3 - x2))
	--            (x, y)' = Lerp(t, Lerp(t, x1, x2), Lerp(t, x2, x3)) - Lerp(t, Lerp(t, x0, x1), Lerp(t, x1, x2)) +
	--                      2 (1 - t) Lerp(t, x1 - x0, x2 - x1) +
	--                      2      t  Lerp(t, x2 - x1, x3 - x2)
	--            (x, y)' = Lerp(t, Lerp(t, x1, x2), Lerp(t, x2, x3)) - Lerp(t, Lerp(t, x0, x1), Lerp(t, x1, x2)) +
	--                      2 Lerp(t, Lerp(t, x1 - x0, x2 - x1), Lerp(t, x2 - x1, x3 - x2))
	--            (x, y)' = Lerp(t, Lerp(t, x1, x2) - Lerp(t, x0, x1), Lerp(t, x2, x3) - Lerp(t, x1, x2)) +
	--                      2 Lerp(t, Lerp(t, x1 - x0, x2 - x1), Lerp(t, x2 - x1, x3 - x2))
	--            (x, y)' =   Lerp(t, Lerp(t, x1 - x0, x2 - x1), Lerp(t, x2 - x1, x3 - x2)) +
	--                      2 Lerp(t, Lerp(t, x1 - x0, x2 - x1), Lerp(t, x2 - x1, x3 - x2))
	--            (x, y)' = 3 Lerp(t, Lerp(t, x1 - x0, x2 - x1), Lerp(t, x2 - x1, x3 - x2))
	local dx0, dy0 = x1 - x0, y1 - y0
	local dx1, dy1 = x2 - x1, y2 - y1
	local dx2, dy2 = x3 - x2, y3 - y2
	
	local dx0, dy0 = UnpackedVector2d_Lerp (t, dx0, dy0, dx1, dy1)
	local dx1, dy1 = UnpackedVector2d_Lerp (t, dx1, dy1, dx2, dy2)
	
	local dx, dy = UnpackedVector2d_Lerp (t, dx0, dy0, dx1, dy1)
	return 3 * dx, 3 * dy
end

function Cat.UnpackedCubicBezier2d.Acceleration (x0, y0, x1, y1, x2, y2, x3, y3, t)
	-- cubic:     (x, y)   = Lerp(t, Lerp(t, Lerp(t, x0, x1), Lerp(t, x1, x2)), Lerp(t, Lerp(t, x1, x2), Lerp(t, x2, x3)))
	--            (x, y)'  = 3 Lerp(t, Lerp(t, x1 - x0, x2 - x1), Lerp(t, x2 - x1, x3 - x2))
	--            (x, y)'' = 3 (Lerp(t, x2 - x1, x3 - x2) - Lerp(t, x1 - x0, x2 - x1)) +
	--                       3 (1 - t) ((x2 - x1) - (x1 - x0)) +
	--                       3      t  ((x3 - x2) - (x2 - x1)) +
	--            (x, y)'' = 3 (Lerp(t, x2 - x1, x3 - x2) - Lerp(t, x1 - x0, x2 - x1)) +
	--                       3 Lerp(t, (x2 - x1) - (x1 - x0), (x3 - x2) - (x2 - x1))
	--            (x, y)'' = 3 Lerp(t, (x2 - x1) - (x1 - x0), (x3 - x2) - (x2 - x1)) +
	--                       3 Lerp(t, (x2 - x1) - (x1 - x0), (x3 - x2) - (x2 - x1))
	--            (x, y)'' = 6 Lerp(t, (x2 - x1) - (x1 - x0), (x3 - x2) - (x2 - x1))
	--            (x, y)'' = 6 Lerp(t, x2 - 2 x1 + x0, x3 - 2 x2 + x1)
	local dx0, dy0 = x2 - 2 * x1 + x0, y2 - 2 * y1 + y0
	local dx1, dy1 = x3 - 2 * x2 + x1, y3 - 2 * y2 + y1
	return 6 * UnpackedVector2d_Lerp (t, dx0, dy0, dx1, dy1)
end

-- nope.avi
-- function Cat.UnpackedCubicBezier2d.Distance (x0, y0, x1, y1, x2, y2, x3, y3, t)
-- end

-- Subdivision
function Cat.UnpackedCubicBezier2d.Subdivide (x0, y0, x1, y1, x2, y2, x3, y3, t)
	local ax0, ay0 = UnpackedVector2d_Lerp (t, x0, y0, x1, y1)
	local ax1, ay1 = UnpackedVector2d_Lerp (t, x1, y1, x2, y2)
	local ax2, ay2 = UnpackedVector2d_Lerp (t, x2, y2, x3, y3)
	
	local bx0, by0 = UnpackedVector2d_Lerp (t, ax0, ay0, ax1, ay1)
	local bx1, by1 = UnpackedVector2d_Lerp (t, ax1, ay1, ax2, ay2)
	
	local midX, midY = UnpackedVector2d_Lerp (t, bx0, by0, bx1, by1)
	
	return x0, y0, ax0, ay0, bx0, by0, midX, midY,
	       midX, midY, bx1, by1, ax2, ay2, x3, y3
end

function Cat.UnpackedCubicBezier2d.SubdivideHalf (x0, y0, x1, y1, x2, y2, x3, y3)
	local ax0, ay0 = 0.5 * (x0 + x1), 0.5 * (y0 + y1)
	local ax1, ay1 = 0.5 * (x1 + x2), 0.5 * (y1 + y2)
	local ax2, ay2 = 0.5 * (x2 + x3), 0.5 * (y2 + y3)
	
	local bx0, by0 = 0.5 * (ax0 + ax1), 0.5 * (ay0 + ay1)
	local bx1, by1 = 0.5 * (ax1 + ax2), 0.5 * (ay1 + ay2)
	
	local midX, midY = 0.5 * (bx0 + bx1), 0.5 * (by0 + by1)
	
	return x0, y0, ax0, ay0, bx0, by0, midX, midY,
	       midX, midY, bx1, by1, ax2, ay2, x3, y3
end

-- Approximation
local UnpackedVector2d_LengthSquared = Cat.UnpackedVector2d.LengthSquared
local UnpackedCubicBezier2d_SubdivideHalf = Cat.UnpackedCubicBezier2d.SubdivideHalf
local function UnpackedCubicBezier2d_ApproximateTail (x0, y0, x1, y1, x2, y2, x3, y3, maximumSpacingSquared, callback)
	if UnpackedVector2d_LengthSquared (x1 - x0, y1 - y0) +
	   UnpackedVector2d_LengthSquared (x2 - x1, y2 - y1) +
	   UnpackedVector2d_LengthSquared (x3 - x2, y3 - y2) > maximumSpacingSquared then
		local _, _, cx0, cy0, cx1, cy1, midX, midY,
			  _, _, cx2, cy2, cx3, cy3, _, _ = UnpackedCubicBezier2d_SubdivideHalf (x0, y0, x1, y1, x2, y2, x3, y3)
		UnpackedCubicBezier2d_ApproximateTail (x0, y0, cx0, cy0, cx1, cy1, midX, midY, maximumSpacingSquared, callback)
		UnpackedCubicBezier2d_ApproximateTail (midX, midY, cx2, cy2, cx3, cy3, x3, y3, maximumSpacingSquared, callback)
	else
		callback (x2, y2)
	end
end

function Cat.UnpackedCubicBezier2d.Approximate (x0, y0, x1, y1, x2, y2, x3, y3, maximumSpacing, callback)
	callback (x0, y0, z0)
	
	UnpackedCubicBezier2d_ApproximateTail (x0, y0, x1, y1, x2, y2, x3, y3, maximumSpacing * maximumSpacing, callback)
end
