local self = {}
Cat.LinearAlgebra.Matrix2x2d = Class (self)

function Cat.LinearAlgebra.Matrix2x2d.Zero (out)
	local out = out or Cat.LinearAlgebra.Matrix2x2d ()
	out [0], out [1] = 0, 0
	out [2], out [3] = 0, 0
	return out
end

function Cat.LinearAlgebra.Matrix2x2d.Identity (out)
	local out = out or Cat.LinearAlgebra.Matrix2x2d ()
	out [0], out [1] = 1, 0
	out [2], out [3] = 0, 1
	return out
end

function self:ctor (m00, m01, m10, m11)
	self [0], self [1] = m00, m01
	self [2], self [3] = m10, m11
end

function Cat.LinearAlgebra.Matrix2x2d.Equals (a, b)
	return a [0] == b [0] and a [1] == b [1] and
	       a [2] == b [2] and a [3] == b [3]
end

self.Equals = Cat.LinearAlgebra.Matrix2x2d.Equals

-- Elements
function Cat.LinearAlgebra.Matrix2x2d.Get (self, y, x)
	local i = y * 2 + x
	return self [i]
end

function Cat.LinearAlgebra.Matrix2x2d.Set (self, y, x, value)
	local i = y * 2 + x
	self [i] = value
	return self
end

self.Get = Cat.LinearAlgebra.Matrix2x2d.Get
self.Set = Cat.LinearAlgebra.Matrix2x2d.Set

-- Arithmetic
function Cat.LinearAlgebra.Matrix2x2d.Add (a, b, out)
	local out = out or Cat.LinearAlgebra.Matrix2x2d ()
	out [0], out [1] = a [0] + b [0], a [1] + b [1]
	out [2], out [3] = a [2] + b [2], a [3] + b [3]
	return out
end

function Cat.LinearAlgebra.Matrix2x2d.Subtract (a, b, out)
	local out = out or Cat.LinearAlgebra.Matrix2x2d ()
	out [0], out [1] = a [0] - b [0], a [1] - b [1]
	out [2], out [3] = a [2] - b [2], a [3] - b [3]
	return out
end

function Cat.LinearAlgebra.Matrix2x2d.Negate (a, out)
	local out = out or Cat.LinearAlgebra.Matrix2x2d ()
	out [0], out [1] = -a [0], -a [1]
	out [2], out [3] = -a [2], -a [3]
	return out
end

function Cat.LinearAlgebra.Matrix2x2d.ScalarMultiply (a, k, out)
	local out = out or Cat.LinearAlgebra.Matrix2x2d ()
	out [0], out [1] = a [0] * k, a [1] * k
	out [2], out [3] = a [2] * k, a [3] * k
	return out
end

function Cat.LinearAlgebra.Matrix2x2d.ScalarDivide (a, k, out)
	local out = out or Cat.LinearAlgebra.Matrix2x2d ()
	out [0], out [1] = a [0] / k, a [1] / k
	out [2], out [3] = a [2] / k, a [3] / k
	return out
end

self.Add            = Cat.LinearAlgebra.Matrix2x2d.Add
self.Subtract       = Cat.LinearAlgebra.Matrix2x2d.Subtract
self.Negate         = Cat.LinearAlgebra.Matrix2x2d.Negate
self.ScalarMultiply = Cat.LinearAlgebra.Matrix2x2d.ScalarMultiply
self.ScalarDivide   = Cat.LinearAlgebra.Matrix2x2d.ScalarDivide

-- Products
function Cat.LinearAlgebra.Matrix2x2d.MatrixMultiply (a, b, out)
	local out = out or Cat.LinearAlgebra.Matrix2x2d ()
	out [0], out [1] = a [0] * b [0] + a [1] * b [2], a [0] * b [1] + a [1] * b [3]
	out [2], out [3] = a [2] * b [0] + a [3] * b [2], a [2] * b [1] + a [3] * b [3]
	return out
end

Cat.LinearAlgebra.Matrix2x2d.Multiply = Cat.LinearAlgebra.Matrix2x2d.MatrixMultiply

function Cat.LinearAlgebra.Matrix2x2d.VectorMultiply (self, v, out)
	local out = out or Cat.LinearAlgebra.Vector2d ()
	out [0] = self [0] * v [0] + self [1] * v [1]
	out [1] = self [2] * v [0] + self [3] * v [1]
	return out
end

self.MatrixMultiply = Cat.LinearAlgebra.Matrix2x2d.MatrixMultiply
self.Multiply       = Cat.LinearAlgebra.Matrix2x2d.Multiply
self.VectorMultiply = Cat.LinearAlgebra.Matrix2x2d.VectorMultiply

-- Matrix operations
function Cat.LinearAlgebra.Matrix2x2d.Determinant (self)
	return self [0] * self [3] - self [2] * self [1]
end

local Cat_LinearAlgebra_Matrix2x2d_Determinant = Cat.LinearAlgebra.Matrix2x2d.Determinant
function Cat.LinearAlgebra.Matrix2x2d.Invert (self, out)
	local out = out or Cat.LinearAlgebra.Matrix2x2d ()
	local k = 1 / Cat_LinearAlgebra_Matrix2x2d_Determinant (self)
	out [0], out [1] =  k * self [3], -k * self [2]
	out [2], out [3] = -k * self [1],  k * self [0]
	return out
end

function Cat.LinearAlgebra.Matrix2x2d.Transpose (self, out)
	local out = out or Cat.LinearAlgebra.Matrix2x2d ()
	out [0], out [3] = self [0], self [3]
	out [1], out [2] = self [2], self [1]
	return out
end

self.Determinant = Cat.LinearAlgebra.Matrix2x2d.Determinant
self.Invert      = Cat.LinearAlgebra.Matrix2x2d.Invert
self.Transpose   = Cat.LinearAlgebra.Matrix2x2d.Transpose

-- Rows and columns
function Cat.LinearAlgebra.Matrix2x2d.GetColumn (self, column, out)
	local out = out or Cat.LinearAlgebra.Vector2d ()
	out [0], out [1] = self [0 + column], self [2 + column]
	return out
end

function Cat.LinearAlgebra.Matrix2x2d.GetRow (self, row, out)
	local out = out or Cat.LinearAlgebra.Vector2d ()
	out [0], out [1] = self [0 + row * 2], self [1 + row * 2]
	return out
end

function Cat.LinearAlgebra.Matrix2x2d.SetColumn (self, column, v)
	self [0 + column], self [2 + column] = v [0], v [1]
	return self
end

function Cat.LinearAlgebra.Matrix2x2d.SetRow (self, row, v)
	self [0 + row * 2], self [1 + row * 2] = v [0], v [1]
	return self
end

self.GetColumn = Cat.LinearAlgebra.Matrix2x2d.GetColumn
self.GetRow    = Cat.LinearAlgebra.Matrix2x2d.GetRow
self.SetColumn = Cat.LinearAlgebra.Matrix2x2d.SetColumn
self.SetRow    = Cat.LinearAlgebra.Matrix2x2d.SetRow

-- Utility
function Cat.LinearAlgebra.Matrix2x2d.ToString (self)
	return "[" .. self [0] .. ", " .. self [1] .. "]\n" ..
	       "[" .. self [2] .. ", " .. self [3] .. "]"
end

self.ToString = Cat.LinearAlgebra.Matrix2x2d.ToString
