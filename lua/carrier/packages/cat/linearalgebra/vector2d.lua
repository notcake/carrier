local self = {}
Cat.Vector2d = Class (self)

function Cat.Vector2d.Zero (out)
	local out = out or Cat.Vector2d ()
	out [0], out [1] = 0, 0
	return out
end

function self:ctor (x, y)
	self [0], self [1] = x, y
end

-- Norms
function Cat.Vector2d.L0Norm (self)
	return math.min (math.abs (self [0]), math.abs (self [1]))
end

function Cat.Vector2d.L1Norm (self)
	return math.abs (self [0]) + math.abs (self [1])
end

function Cat.Vector2d.L2Norm (self)
	return math.sqrt (self [0] * self [0] + self [1] * self [1])
end

function Cat.Vector2d.L2NormSquared (self)
	return self [0] * self [0] + self [1] * self [1]
end

function Cat.Vector2d.LInfinityNorm (self)
	return math.max (math.abs (self [0]), math.abs (self [1]))
end

Cat.Vector2d.Length        = Cat.Vector2d.L2Norm
Cat.Vector2d.LengthSquared = Cat.Vector2d.L2NormSquared

function Cat.Vector2d.Distance (a, b)
	local dx, dy = b [0] - a [0], b [1] - a [1]
	return math.sqrt (dx * dx + dy * dy)
end

function Cat.Vector2d.DistanceSquared (a, b)
	local dx, dy = b [0] - a [0], b [1] - a [1]
	return dx * dx + dy * dy
end

self.L0Norm          = Cat.Vector2d.L0Norm
self.L1Norm          = Cat.Vector2d.L1Norm
self.L2Norm          = Cat.Vector2d.L2Norm
self.L2NormSquared   = Cat.Vector2d.L2NormSquared
self.LInfinityNorm   = Cat.Vector2d.LInfinityNorm
self.Length          = Cat.Vector2d.Length
self.LengthSquared   = Cat.Vector2d.LengthSquared
self.Distance        = Cat.Vector2d.Distance
self.DistanceSquared = Cat.Vector2d.DistanceSquared

-- Arithmetic
function Cat.Vector2d.Add (a, b, out)
	local out = out or Cat.Vector2d ()
	out [0], out [1] = a [0] + b [0], a [1] + b [1]
	return out
end

function Cat.Vector2d.Subtract (a, b, out)
	local out = out or Cat.Vector2d ()
	out [0], out [1] = a [0] - b [0], a [1] - b [1]
	return out
end

function Cat.Vector2d.Negate (a, out)
	local out = out or Cat.Vector2d ()
	out [0], out [1] = -a [0], -a [1]
	return out
end

function Cat.Vector2d.ScalarMultiply (a, k, out)
	local out = out or Cat.Vector2d ()
	out [0], out [1] = a [0] * k, a [1] * k
	return out
end

function Cat.Vector2d.ScalarDivide (a, k, out)
	local out = out or Cat.Vector2d ()
	out [0], out [1] = a [0] / k, a [1] / k
	return out
end

self.Add            = Cat.Vector2d.Add
self.Subtract       = Cat.Vector2d.Subtract
self.Negate         = Cat.Vector2d.Negate
self.ScalarMultiply = Cat.Vector2d.ScalarMultiply
self.ScalarDivide   = Cat.Vector2d.ScalarDivide

-- Products
function Cat.Vector2d.InnerProduct (a, b)
	return a [0] * b [0] + a [1] * b [1]
end

function Cat.Vector2d.OuterProduct (a, b, out)
	local out = out or Cat.Matrix2x2d ()
	out [0], out [1] = a [0] * b [0], a [0] * b [1]
	out [2], out [3] = a [1] * b [0], a [1] * b [1]
	return out
end

function Cat.Vector2d.CrossProduct (a, b)
	return a [0] * b [1] - a [1] * b [0]
end

Cat.Vector2d.DotProduct = Cat.Vector2d.InnerProduct
Cat.Vector2d.Dot        = Cat.Vector2d.InnerProduct
Cat.Vector2d.Cross      = Cat.Vector2d.CrossProduct

self.InnerProduct = Cat.Vector2d.InnerProduct
self.OuterProduct = Cat.Vector2d.OuterProduct
self.CrossProduct = Cat.Vector2d.CrossProduct
self.DotProduct   = Cat.Vector2d.DotProduct
self.Dot          = Cat.Vector2d.Dot
self.Cross        = Cat.Vector2d.Cross

-- Utility
function Cat.Vector2d.Clone (self, out)
	local out = out or Cat.Vector2d ()
	out [0], out [1] = self [0], self [1]
	return out
end

function Cat.Vector2d.Equals (a, b)
	return a [0] == b [0] and a [1] == b [1]
end

function Cat.Vector2d.Lerp (t, a, b, out)
	local out = out or Cat.Vector2d ()
	out [0] = t * b [0] + (1 - t) * a [0]
	out [1] = t * b [1] + (1 - t) * a [1]
	return out
end

function Cat.Vector2d.ToString (self)
	return "(" .. self [0] .. ", " .. self [1] .. ")"
end

self.Clone    = Cat.Vector2d.Clone
self.Equals   = Cat.Vector2d.Equals
self.ToString = Cat.Vector2d.ToString
