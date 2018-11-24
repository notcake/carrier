local self = {}
Cat.LinearAlgebra.Vector4d = Class(self)

local math_abs  = math.abs
local math_max  = math.max
local math_min  = math.min
local math_sqrt = math.sqrt

function Cat.LinearAlgebra.Vector4d.Zero(out)
	local out = out or Cat.LinearAlgebra.Vector4d()
	out[0], out[1], out[2], out[3] = 0, 0, 0, 0
	return out
end

function Cat.LinearAlgebra.Vector4d.FromVector3d(v, out)
	local out = out or Cat.LinearAlgebra.Vector4d()
	out[0], out[1], out[2], out[3] = v[0], v[1], v[2], 0
	return out
end

function Cat.LinearAlgebra.Vector4d.ToVector3d(v, out)
	local out = out or Cat.LinearAlgebra.Vector3d()
	out[0], out[1], out[2] = self[0], self[1], self[2]
	return out
end

function self:ctor(x, y, z, w)
	self[0], self[1], self[2], self[3] = x, y, z, w
end

self.ToVector3d = Cat.LinearAlgebra.Vector4d.ToVector3d

-- Norms
function Cat.LinearAlgebra.Vector4d.LNegativeInfinityNorm(self)
	return math_min(math_abs(self[0]), math_abs(self[1]), math_abs(self[2]), math_abs(self[3]))
end

function Cat.LinearAlgebra.Vector4d.L1Norm(self)
	return math_abs(self[0]) + math_abs(self[1]) + math_abs(self[2]) + math_abs(self[3])
end

function Cat.LinearAlgebra.Vector4d.L2Norm(self)
	return math_sqrt(self[0] * self[0] + self[1] * self[1] + self[2] * self[2] + self[3] * self[3])
end

function Cat.LinearAlgebra.Vector4d.L2NormSquared(self)
	return self[0] * self[0] + self[1] * self[1] + self[2] * self[2] + self[3] * self[3]
end

function Cat.LinearAlgebra.Vector4d.LInfinityNorm(self)
	return math_max(math_abs(self[0]), math_abs(self[1]), math_abs(self[2]), math_abs(self[3]))
end

Cat.LinearAlgebra.Vector4d.Length        = Cat.LinearAlgebra.Vector4d.L2Norm
Cat.LinearAlgebra.Vector4d.LengthSquared = Cat.LinearAlgebra.Vector4d.L2NormSquared

function Cat.LinearAlgebra.Vector4d.Distance(a, b)
	local dx, dy, dz, dw = b[0] - a[0], b[1] - a[1], b[2] - a[2], b[3] - a[3]
	return math_sqrt(dx * dx + dy * dy + dz * dz + dw * dw)
end

function Cat.LinearAlgebra.Vector4d.DistanceSquared(a, b)
	local dx, dy, dz, dw = b[0] - a[0], b[1] - a[1], b[2] - a[2], b[3] - a[3]
	return dx * dx + dy * dy + dz * dz + dw * dw
end

self.LNegativeInfinityNorm = Cat.LinearAlgebra.Vector4d.LNegativeInfinityNorm
self.L1Norm                = Cat.LinearAlgebra.Vector4d.L1Norm
self.L2Norm                = Cat.LinearAlgebra.Vector4d.L2Norm
self.L2NormSquared         = Cat.LinearAlgebra.Vector4d.L2NormSquared
self.LInfinityNorm         = Cat.LinearAlgebra.Vector4d.LInfinityNorm
self.Length                = Cat.LinearAlgebra.Vector4d.Length
self.LengthSquared         = Cat.LinearAlgebra.Vector4d.LengthSquared
self.Distance              = Cat.LinearAlgebra.Vector4d.Distance
self.DistanceSquared       = Cat.LinearAlgebra.Vector4d.DistanceSquared

-- Arithmetic
function Cat.LinearAlgebra.Vector4d.Add(a, b, out)
	local out = out or Cat.LinearAlgebra.Vector4d()
	out[0], out[1], out[2], out[3] = a[0] + b[0], a[1] + b[1], a[2] + b[2], a[3] + b[3]
	return out
end

function Cat.LinearAlgebra.Vector4d.Subtract(a, b, out)
	local out = out or Cat.LinearAlgebra.Vector4d()
	out[0], out[1], out[2], out[3] = a[0] - b[0], a[1] - b[1], a[2] - b[2], a[3] - b[3]
	return out
end

function Cat.LinearAlgebra.Vector4d.Negate(a, out)
	local out = out or Cat.LinearAlgebra.Vector4d()
	out[0], out[1], out[2], out[3] = -a[0], -a[1], -a[2], -a[3]
	return out
end

function Cat.LinearAlgebra.Vector4d.ScalarMultiply(a, k, out)
	local out = out or Cat.LinearAlgebra.Vector4d()
	out[0], out[1], out[2], out[3] = a[0] * k, a[1] * k, a[2] * k, a[3] * k
	return out
end

function Cat.LinearAlgebra.Vector4d.ScalarDivide(a, k, out)
	local out = out or Cat.LinearAlgebra.Vector4d()
	out[0], out[1], out[2], out[3] = a[0] / k, a[1] / k, a[2] / k, a[3] / k
	return out
end

self.Add            = Cat.LinearAlgebra.Vector4d.Add
self.Subtract       = Cat.LinearAlgebra.Vector4d.Subtract
self.Negate         = Cat.LinearAlgebra.Vector4d.Negate
self.ScalarMultiply = Cat.LinearAlgebra.Vector4d.ScalarMultiply
self.ScalarDivide   = Cat.LinearAlgebra.Vector4d.ScalarDivide

-- Products
function Cat.LinearAlgebra.Vector4d.InnerProduct(a, b)
	return a[0] * b[0] + a[1] * b[1] + a[2] * b[2] + a[3] * b[3]
end

function Cat.LinearAlgebra.Vector4d.OuterProduct(a, b, out)
	local out = out or Cat.LinearAlgebra.Matrix4x4d()
	out[ 0], out[ 1], out[ 2], out[ 3] = a[0] * b[0], a[0] * b[1], a[0] * b[2], a[0] * b[3]
	out[ 4], out[ 5], out[ 6], out[ 7] = a[1] * b[0], a[1] * b[1], a[1] * b[2], a[1] * b[3]
	out[ 8], out[ 9], out[10], out[11] = a[2] * b[0], a[2] * b[1], a[2] * b[2], a[2] * b[3]
	out[12], out[13], out[14], out[15] = a[3] * b[0], a[3] * b[1], a[3] * b[2], a[3] * b[3]
	return out
end

Cat.LinearAlgebra.Vector4d.DotProduct = Cat.LinearAlgebra.Vector4d.InnerProduct
Cat.LinearAlgebra.Vector4d.Dot        = Cat.LinearAlgebra.Vector4d.InnerProduct

self.InnerProduct = Cat.LinearAlgebra.Vector4d.InnerProduct
self.OuterProduct = Cat.LinearAlgebra.Vector4d.OuterProduct
self.DotProduct   = Cat.LinearAlgebra.Vector4d.DotProduct
self.Dot          = Cat.LinearAlgebra.Vector4d.Dot

-- Utility
function Cat.LinearAlgebra.Vector4d.Clone(self, out)
	local out = out or Cat.LinearAlgebra.Vector4d()
	out[0], out[1], out[2], out[3] = self[0], self[1], self[2], self[3]
	return out
end

function Cat.LinearAlgebra.Vector4d.Equals(a, b)
	return a[0] == b[0] and a[1] == b[1] and a[2] == b[2] and a[3] == b[3]
end

function Cat.LinearAlgebra.Vector4d.Lerp(t, a, b, out)
	local out = out or Cat.LinearAlgebra.Vector4d()
	out[0] = t * b[0] + (1 - t) * a[0]
	out[1] = t * b[1] + (1 - t) * a[1]
	out[2] = t * b[2] + (1 - t) * a[2]
	out[3] = t * b[3] + (1 - t) * a[3]
	return out
end

function Cat.LinearAlgebra.Vector4d.ToString(self)
	return "(" .. self[0] .. ", " .. self[1] .. ", " .. self[2] .. ", " .. self[3] .. ")"
end

self.Clone    = Cat.LinearAlgebra.Vector4d.Clone
self.Equals   = Cat.LinearAlgebra.Vector4d.Equals
self.ToString = Cat.LinearAlgebra.Vector4d.ToString
