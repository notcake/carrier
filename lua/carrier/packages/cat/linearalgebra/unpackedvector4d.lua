Cat.LinearAlgebra.UnpackedVector4d = Table.Callable (
	function (x, y, z, w)
		return x, y, z, w
	end
)

function Cat.LinearAlgebra.UnpackedVector4d.Zero ()
	return 0, 0, 0, 0
end

-- Norms
function Cat.LinearAlgebra.UnpackedVector4d.L0Norm (x, y, z, w)
	return math.min (math.abs (x), math.abs (y), math.abs (z), math.abs (w))
end

function Cat.LinearAlgebra.UnpackedVector4d.L1Norm (x, y, z, w)
	return math.abs (x) + math.abs (y) + math.abs (z) + math.abs (w)
end

function Cat.LinearAlgebra.UnpackedVector4d.L2Norm (x, y, z, w)
	return math.sqrt (x * x + y * y + z * z + w * w)
end

function Cat.LinearAlgebra.UnpackedVector4d.L2NormSquared (x, y, z, w)
	return x * x + y * y + z * z + w * w
end

function Cat.LinearAlgebra.UnpackedVector4d.LInfinityNorm (x, y, z, w)
	return math.max (math.abs (x), math.abs (y), math.abs (z), math.abs (w))
end

Cat.LinearAlgebra.UnpackedVector4d.Length        = Cat.LinearAlgebra.UnpackedVector4d.L2Norm
Cat.LinearAlgebra.UnpackedVector4d.LengthSquared = Cat.LinearAlgebra.UnpackedVector4d.L2NormSquared

function Cat.LinearAlgebra.UnpackedVector4d.Distance (x1, y1, z1, w1, x2, y2, z2, w2)
	local dx, dy, dz, dw = x2 - x1, y2 - y1, z2 - z1, w2 - w1
	return math.sqrt (dx * dx + dy * dy + dz * dz + dw * dw)
end

function Cat.LinearAlgebra.UnpackedVector4d.DistanceSquared (x1, y1, z1, w1, x2, y2, z2, w2)
	local dx, dy, dz, dw = x2 - x1, y2 - y1, z2 - z1, w2 - w1
	return dx * dx + dy * dy + dz * dz + dw * dw
end

-- Arithmetic
function Cat.LinearAlgebra.UnpackedVector4d.Add (x1, y1, z1, w1, x2, y2, z2, w2)
	return x1 + x2, y1 + y2, z1 + z2, w1 + w2
end

function Cat.LinearAlgebra.UnpackedVector4d.Subtract (x1, y1, z1, w1, x2, y2, z2, w2)
	return x1 - x2, y1 - y2, z1 - z2, w1 - w2
end

function Cat.LinearAlgebra.UnpackedVector4d.Negate (x, y, z, w)
	return -x, -y, -z, -w
end

function Cat.LinearAlgebra.UnpackedVector4d.ScalarMultiply (x, y, z, w, k)
	return x * k, y * k, z * k, w * k
end

function Cat.LinearAlgebra.UnpackedVector4d.ScalarDivide (x, y, z, w, k)
	return x / k, y / k, z / k, w / k
end

-- Products
function Cat.LinearAlgebra.UnpackedVector4d.InnerProduct (x1, y1, z1, w1, x2, y2, z2, w2)
	return x1 * x2 + y1 * y2 + z1 * z2 + w1 * w2
end

function Cat.LinearAlgebra.UnpackedVector4d.OuterProduct (x1, y1, z1, w1, x2, y2, z2, w2)
	return x1 * x2, x1 * y2, x1 * z2, x1 * w2,
	       y1 * x2, y1 * y2, y1 * z2, y1 * w2,
	       z1 * x2, z1 * y2, z1 * z2, z1 * w2,
	       w1 * x2, w1 * y2, w1 * z2, w1 * w2
end

Cat.LinearAlgebra.UnpackedVector4d.DotProduct = Cat.LinearAlgebra.UnpackedVector4d.InnerProduct
Cat.LinearAlgebra.UnpackedVector4d.Dot        = Cat.LinearAlgebra.UnpackedVector4d.InnerProduct

-- Utility
function Cat.LinearAlgebra.UnpackedVector4d.Equals (x1, y1, z1, w1, x2, y2, z2, w2)
	return x1 == x2 and y1 == y2 and z1 == z2 and w1 == w2
end

function Cat.LinearAlgebra.UnpackedVector4d.Lerp (t, x1, y1, z1, w1, x2, y2, z2, w2)
	return t * x2 + (1 - t) * x1,
	       t * y2 + (1 - t) * y1,
	       t * z2 + (1 - t) * z1,
	       t * w2 + (1 - t) * w1
end

function Cat.LinearAlgebra.UnpackedVector4d.ToString (x, y, z, w)
	return "(" .. x .. ", " .. y .. ", " .. z .. ", " .. w .. ")"
end
