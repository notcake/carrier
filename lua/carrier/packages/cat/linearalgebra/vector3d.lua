local self = {}
Cat.LinearAlgebra.Vector3d = Class (self)

local math_abs  = math.abs
local math_max  = math.max
local math_min  = math.min
local math_sqrt = math.sqrt

function Cat.LinearAlgebra.Vector3d.Zero (out)
	local out = out or Cat.LinearAlgebra.Vector3d ()
	out [0], out [1], out [2] = 0, 0, 0
	return out
end

function Cat.LinearAlgebra.Vector3d.FromVector2d (v, out)
	local out = out or Cat.LinearAlgebra.Vector3d ()
	out [0], out [1], out [2] = v [0], v [1], 0
	return out
end

function Cat.LinearAlgebra.Vector3d.ToVector2d (v, out)
	local out = out or Cat.LinearAlgebra.Vector2d ()
	out [0], out [1] = self [0], self [1]
	return out
end

function self:ctor (x, y, z)
	self [0], self [1], self [2] = x, y, z
end

self.ToVector2d = Cat.LinearAlgebra.Vector3d.ToVector2d

-- Norms
function Cat.LinearAlgebra.Vector3d.LNegativeInfinityNorm (self)
	return math_min (math_abs (self [0]), math_abs (self [1]), math_abs (self [2]))
end

function Cat.LinearAlgebra.Vector3d.L1Norm (self)
	return math_abs (self [0]) + math_abs (self [1]) + math_abs (self [2])
end

function Cat.LinearAlgebra.Vector3d.L2Norm (self)
	return math_sqrt (self [0] * self [0] + self [1] * self [1] + self [2] * self [2])
end

function Cat.LinearAlgebra.Vector3d.L2NormSquared (self)
	return self [0] * self [0] + self [1] * self [1] + self [2] * self [2]
end

function Cat.LinearAlgebra.Vector3d.LInfinityNorm (self)
	return math_max (math_abs (self [0]), math_abs (self [1]), math_abs (self [2]))
end

Cat.LinearAlgebra.Vector3d.Length        = Cat.LinearAlgebra.Vector3d.L2Norm
Cat.LinearAlgebra.Vector3d.LengthSquared = Cat.LinearAlgebra.Vector3d.L2NormSquared

function Cat.LinearAlgebra.Vector3d.Distance (a, b)
	local dx, dy, dz = b [0] - a [0], b [1] - a [1], b [2] - a [2]
	return math_sqrt (dx * dx + dy * dy + dz * dz)
end

function Cat.LinearAlgebra.Vector3d.DistanceSquared (a, b)
	local dx, dy, dz = b [0] - a [0], b [1] - a [1], b [2] - a [2]
	return dx * dx + dy * dy + dz * dz
end

self.LNegativeInfinityNorm = Cat.LinearAlgebra.Vector3d.LNegativeInfinityNorm
self.L1Norm                = Cat.LinearAlgebra.Vector3d.L1Norm
self.L2Norm                = Cat.LinearAlgebra.Vector3d.L2Norm
self.L2NormSquared         = Cat.LinearAlgebra.Vector3d.L2NormSquared
self.LInfinityNorm         = Cat.LinearAlgebra.Vector3d.LInfinityNorm
self.Length                = Cat.LinearAlgebra.Vector3d.Length
self.LengthSquared         = Cat.LinearAlgebra.Vector3d.LengthSquared
self.Distance              = Cat.LinearAlgebra.Vector3d.Distance
self.DistanceSquared       = Cat.LinearAlgebra.Vector3d.DistanceSquared

-- Arithmetic
function Cat.LinearAlgebra.Vector3d.Add (a, b, out)
	local out = out or Cat.LinearAlgebra.Vector3d ()
	out [0], out [1], out [2] = a [0] + b [0], a [1] + b [1], a [2] + b [2]
	return out
end

function Cat.LinearAlgebra.Vector3d.Subtract (a, b, out)
	local out = out or Cat.LinearAlgebra.Vector3d ()
	out [0], out [1], out [2] = a [0] - b [0], a [1] - b [1], a [2] - b [2]
	return out
end

function Cat.LinearAlgebra.Vector3d.Negate (a, out)
	local out = out or Cat.LinearAlgebra.Vector3d ()
	out [0], out [1], out [2] = -a [0], -a [1], -a [2]
	return out
end

function Cat.LinearAlgebra.Vector3d.ScalarMultiply (a, k, out)
	local out = out or Cat.LinearAlgebra.Vector3d ()
	out [0], out [1], out [2] = a [0] * k, a [1] * k, a [2] * k
	return out
end

function Cat.LinearAlgebra.Vector3d.ScalarDivide (a, k, out)
	local out = out or Cat.LinearAlgebra.Vector3d ()
	out [0], out [1], out [2] = a [0] / k, a [1] / k, a [2] / k
	return out
end

self.Add            = Cat.LinearAlgebra.Vector3d.Add
self.Subtract       = Cat.LinearAlgebra.Vector3d.Subtract
self.Negate         = Cat.LinearAlgebra.Vector3d.Negate
self.ScalarMultiply = Cat.LinearAlgebra.Vector3d.ScalarMultiply
self.ScalarDivide   = Cat.LinearAlgebra.Vector3d.ScalarDivide

-- Products
function Cat.LinearAlgebra.Vector3d.InnerProduct (a, b)
	return a [0] * b [0] + a [1] * b [1] + a [2] * b [2]
end

function Cat.LinearAlgebra.Vector3d.OuterProduct (a, b, out)
	local out = out or Cat.LinearAlgebra.Matrix3x3d ()
	out [0], out [1], out [2] = a [0] * b [0], a [0] * b [1], a [0] * b [2]
	out [3], out [4], out [5] = a [1] * b [0], a [1] * b [1], a [1] * b [2]
	out [6], out [7], out [8] = a [2] * b [0], a [2] * b [1], a [2] * b [2]
	return out
end

function Cat.LinearAlgebra.Vector3d.CrossProduct (a, b, out)
	local out = out or Cat.LinearAlgebra.Vector3d ()
	out [0] = a [1] * b [2] - a [2] * b [1]
	out [1] = a [2] * b [0] - a [0] * b [2]
	out [2] = a [0] * b [1] - a [1] * b [0]
	return out
end

Cat.LinearAlgebra.Vector3d.DotProduct = Cat.LinearAlgebra.Vector3d.InnerProduct
Cat.LinearAlgebra.Vector3d.Dot        = Cat.LinearAlgebra.Vector3d.InnerProduct
Cat.LinearAlgebra.Vector3d.Cross      = Cat.LinearAlgebra.Vector3d.CrossProduct

self.InnerProduct = Cat.LinearAlgebra.Vector3d.InnerProduct
self.OuterProduct = Cat.LinearAlgebra.Vector3d.OuterProduct
self.CrossProduct = Cat.LinearAlgebra.Vector3d.CrossProduct
self.DotProduct   = Cat.LinearAlgebra.Vector3d.DotProduct
self.Dot          = Cat.LinearAlgebra.Vector3d.Dot
self.Cross        = Cat.LinearAlgebra.Vector3d.Cross

-- Utility
function Cat.LinearAlgebra.Vector3d.Clone (self, out)
	local out = out or Cat.LinearAlgebra.Vector3d ()
	out [0], out [1], out [2] = self [0], self [1], self [2]
	return out
end

function Cat.LinearAlgebra.Vector3d.Equals (a, b)
	return a [0] == b [0] and a [1] == b [1] and a [2] == b [2]
end

function Cat.LinearAlgebra.Vector3d.Lerp (t, a, b, out)
	local out = out or Cat.LinearAlgebra.Vector3d ()
	out [0] = t * b [0] + (1 - t) * a [0]
	out [1] = t * b [1] + (1 - t) * a [1]
	out [2] = t * b [2] + (1 - t) * a [2]
	return out
end

function Cat.LinearAlgebra.Vector3d.ToString (self)
	return "(" .. self [0] .. ", " .. self [1] .. ", " .. self [2] .. ")"
end

self.Clone    = Cat.LinearAlgebra.Vector3d.Clone
self.Equals   = Cat.LinearAlgebra.Vector3d.Equals
self.ToString = Cat.LinearAlgebra.Vector3d.ToString
