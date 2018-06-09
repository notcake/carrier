Cat.LinearAlgebra.UnpackedVector2d = Table.Callable (
	function (x, y)
		return x, y
	end
)

function Cat.LinearAlgebra.UnpackedVector2d.Zero ()
	return 0, 0
end

-- Norms
function Cat.LinearAlgebra.UnpackedVector2d.L0Norm (x, y)
	return math.min (math.abs (x), math.abs (y))
end

function Cat.LinearAlgebra.UnpackedVector2d.L1Norm (x, y)
	return math.abs (x) + math.abs (y)
end

function Cat.LinearAlgebra.UnpackedVector2d.L2Norm (x, y)
	return math.sqrt (x * x + y * y)
end

function Cat.LinearAlgebra.UnpackedVector2d.L2NormSquared (x, y)
	return x * x + y * y
end

function Cat.LinearAlgebra.UnpackedVector2d.LInfinityNorm (x, y)
	return math.max (math.abs (x), math.abs (y))
end

Cat.LinearAlgebra.UnpackedVector2d.Length        = Cat.LinearAlgebra.UnpackedVector2d.L2Norm
Cat.LinearAlgebra.UnpackedVector2d.LengthSquared = Cat.LinearAlgebra.UnpackedVector2d.L2NormSquared

function Cat.LinearAlgebra.UnpackedVector2d.Distance (x1, y1, x2, y2)
	local dx, dy = x2 - x1, y2 - y1
	return math.sqrt (dx * dx + dy * dy)
end

function Cat.LinearAlgebra.UnpackedVector2d.DistanceSquared (x1, y1, x2, y2)
	local dx, dy = x2 - x1, y2 - y1
	return dx * dx + dy * dy
end

-- Arithmetic
function Cat.LinearAlgebra.UnpackedVector2d.Add (x1, y1, x2, y2)
	return x1 + x2, y1 + y2
end

function Cat.LinearAlgebra.UnpackedVector2d.Subtract (x1, y1, x2, y2)
	return x1 - x2, y1 - y2
end

function Cat.LinearAlgebra.UnpackedVector2d.Negate (x, y)
	return -x, -y
end

function Cat.LinearAlgebra.UnpackedVector2d.ScalarMultiply (x, y, k)
	return x * k, y * k
end

function Cat.LinearAlgebra.UnpackedVector2d.ScalarDivide (x, y, k)
	return x / k, y / k
end

-- Products
function Cat.LinearAlgebra.UnpackedVector2d.InnerProduct (x1, y1, x2, y2)
	return x1 * x2 + y1 * y2
end

function Cat.LinearAlgebra.UnpackedVector2d.OuterProduct (x1, y1, x2, y2)
	return x1 * x2, x1 * y2,
	       y1 * x2, y1 * y2
end

function Cat.LinearAlgebra.UnpackedVector2d.CrossProduct (x1, y1, x2, y2)
	return x1 * y2 - y1 * x2
end

Cat.LinearAlgebra.UnpackedVector2d.DotProduct = Cat.LinearAlgebra.UnpackedVector2d.InnerProduct
Cat.LinearAlgebra.UnpackedVector2d.Dot        = Cat.LinearAlgebra.UnpackedVector2d.InnerProduct
Cat.LinearAlgebra.UnpackedVector2d.Cross      = Cat.LinearAlgebra.UnpackedVector2d.Cross

-- Utility
function Cat.LinearAlgebra.UnpackedVector2d.Clone (x, y)
	return x, y
end

function Cat.LinearAlgebra.UnpackedVector2d.Equals (x1, y1, x2, y2)
	return x1 == x2 and y1 == y2
end

function Cat.LinearAlgebra.UnpackedVector2d.Lerp (t, x1, y1, x2, y2)
	return t * x2 + (1 - t) * x1,
	       t * y2 + (1 - t) * y1
end

function Cat.LinearAlgebra.UnpackedVector2d.ToString (x, y)
	return "(" .. x .. ", " .. y .. ")"
end
