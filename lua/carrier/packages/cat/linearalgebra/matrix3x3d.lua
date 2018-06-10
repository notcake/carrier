local self = {}
Cat.LinearAlgebra.Matrix3x3d = Class (self)

function Cat.LinearAlgebra.Matrix3x3d.Zero (out)
	local out = out or Cat.LinearAlgebra.Matrix3x3d ()
	out [0], out [1], out [2] = 0, 0, 0
	out [3], out [4], out [5] = 0, 0, 0
	out [6], out [7], out [8] = 0, 0, 0
	return out
end

function Cat.LinearAlgebra.Matrix3x3d.Identity (out)
	local out = out or Cat.LinearAlgebra.Matrix3x3d ()
	out [0], out [1], out [2] = 1, 0, 0
	out [3], out [4], out [5] = 0, 1, 0
	out [6], out [7], out [8] = 0, 0, 1
	return out
end

function Cat.LinearAlgebra.Matrix3x3d.FromMatrix2x2d (m, out)
	local out = out or Cat.LinearAlgebra.Matrix3x3d ()
	out [0], out [1], out [2] = m [0], m [1], 0
	out [3], out [4], out [5] = m [2], m [3], 0
	out [6], out [7], out [8] =     0,     0, 1
	return out
end

function Cat.LinearAlgebra.Matrix3x3d.ToMatrix2x2d (self, out)
	local out = out or Cat.LinearAlgebra.Matrix2x2d ()
	out [0], out [1] = self [0], self [1]
	out [2], out [3] = self [3], self [4]
	return out
end

function self:ctor (m00, m01, m02, m10, m11, m12, m20, m21, m22)
	self [0], self [1], self [2] = m00, m01, m02
	self [3], self [4], self [5] = m10, m11, m12
	self [6], self [7], self [8] = m20, m21, m22
end

function Cat.LinearAlgebra.Matrix3x3d.Equals (a, b)
	return a [0] == b [0] and a [1] == b [1] and a [2] == b [2] and
	       a [3] == b [3] and a [4] == b [4] and a [5] == b [5] and
	       a [6] == b [6] and a [7] == b [7] and a [8] == b [8]
end

self.ToMatrix2x2d = Cat.LinearAlgebra.Matrix3x3d.ToMatrix2x2d
self.Equals       = Cat.LinearAlgebra.Matrix3x3d.Equals

-- Elements
function Cat.LinearAlgebra.Matrix3x3d.Get (self, y, x)
	local i = y * 3 + x
	return self [i]
end

function Cat.LinearAlgebra.Matrix3x3d.Set (self, y, x, value)
	local i = y * 3 + x
	self [i] = value
	return self
end

self.Get = Cat.LinearAlgebra.Matrix3x3d.Get
self.Set = Cat.LinearAlgebra.Matrix3x3d.Set

-- Arithmetic
function Cat.LinearAlgebra.Matrix3x3d.Add (a, b, out)
	local out = out or Cat.LinearAlgebra.Matrix3x3d ()
	out [0], out [1], out [2] = a [0] + b [0], a [1] + b [1], a [2] + b [2]
	out [3], out [4], out [5] = a [3] + b [3], a [4] + b [4], a [5] + b [5]
	out [6], out [7], out [8] = a [6] + b [6], a [7] + b [7], a [8] + b [8]
	return out
end

function Cat.LinearAlgebra.Matrix3x3d.Subtract (a, b, out)
	local out = out or Cat.LinearAlgebra.Matrix3x3d ()
	out [0], out [1], out [2] = a [0] - b [0], a [1] - b [1], a [2] - b [2]
	out [3], out [4], out [5] = a [3] - b [3], a [4] - b [4], a [5] - b [5]
	out [6], out [7], out [8] = a [6] - b [6], a [7] - b [7], a [8] - b [8]
	return out
end

function Cat.LinearAlgebra.Matrix3x3d.Negate (a, out)
	local out = out or Cat.LinearAlgebra.Matrix3x3d ()
	out [0], out [1], out [2] = -a [0], -a [1], -a [2]
	out [3], out [4], out [5] = -a [3], -a [4], -a [5]
	out [6], out [7], out [8] = -a [6], -a [7], -a [8]
	return out
end

function Cat.LinearAlgebra.Matrix3x3d.ScalarMultiply (a, k, out)
	local out = out or Cat.LinearAlgebra.Matrix3x3d ()
	out [0], out [1], out [2] = a [0] * k, a [1] * k, a [2] * k
	out [3], out [4], out [5] = a [3] * k, a [4] * k, a [5] * k
	out [6], out [7], out [8] = a [6] * k, a [7] * k, a [8] * k
	return out
end

function Cat.LinearAlgebra.Matrix3x3d.ScalarDivide (a, k, out)
	local out = out or Cat.LinearAlgebra.Matrix3x3d ()
	out [0], out [1], out [2] = a [0] / k, a [1] / k, a [2] / k
	out [3], out [4], out [5] = a [3] / k, a [4] / k, a [5] / k
	out [6], out [7], out [8] = a [6] / k, a [7] / k, a [8] / k
	return out
end

self.Add            = Cat.LinearAlgebra.Matrix3x3d.Add
self.Subtract       = Cat.LinearAlgebra.Matrix3x3d.Subtract
self.Negate         = Cat.LinearAlgebra.Matrix3x3d.Negate
self.ScalarMultiply = Cat.LinearAlgebra.Matrix3x3d.ScalarMultiply
self.ScalarDivide   = Cat.LinearAlgebra.Matrix3x3d.ScalarDivide

-- Products
function Cat.LinearAlgebra.Matrix3x3d.MatrixMultiply (a, b, out)
	local out = out or Cat.LinearAlgebra.Matrix3x3d ()
	out [0], out [1], out [2] = a [0] * b [0] + a [1] * b [3] + a [2] * b [6], a [0] * b [1] + a [1] * b [4] + a [2] * b [7], a [0] * b [2] + a [1] * b [5] + a [2] * b [8]
	out [3], out [4], out [5] = a [3] * b [0] + a [4] * b [3] + a [5] * b [6], a [3] * b [1] + a [4] * b [4] + a [5] * b [7], a [3] * b [2] + a [4] * b [5] + a [5] * b [8]
	out [6], out [7], out [8] = a [6] * b [0] + a [7] * b [3] + a [8] * b [6], a [6] * b [1] + a [7] * b [4] + a [8] * b [7], a [6] * b [2] + a [7] * b [5] + a [8] * b [8]
	return out
end

Cat.LinearAlgebra.Matrix3x3d.Multiply = Cat.LinearAlgebra.Matrix3x3d.MatrixMultiply

function Cat.LinearAlgebra.Matrix3x3d.VectorMultiply (self, v, out)
	local out = out or Cat.LinearAlgebra.Vector3d ()
	out [0] = self [0] * v [0] + self [1] * v [1] + self [2] * v [2]
	out [1] = self [3] * v [0] + self [4] * v [1] + self [5] * v [2]
	out [2] = self [6] * v [0] + self [7] * v [1] + self [8] * v [2]
	return out
end

self.MatrixMultiply = Cat.LinearAlgebra.Matrix3x3d.MatrixMultiply
self.Multiply       = Cat.LinearAlgebra.Matrix3x3d.Multiply
self.VectorMultiply = Cat.LinearAlgebra.Matrix3x3d.VectorMultiply

-- Matrix operations
function Cat.LinearAlgebra.Matrix3x3d.Determinant (self)
	return   self [0] * (self [4] * self [8] - self [7] * self [5])
	       - self [3] * (self [1] * self [8] - self [7] * self [2])
	       + self [6] * (self [1] * self [5] - self [4] * self [2])
end

local Cat_LinearAlgebra_Matrix3x3d_Determinant = Cat.LinearAlgebra.Matrix3x3d.Determinant
function Cat.LinearAlgebra.Matrix3x3d.Invert (self, out)
	local out = out or Cat.LinearAlgebra.Matrix3x3d ()
	local k = 1 / Cat_LinearAlgebra_Matrix3x3d_Determinant (self)
	out [0], out [1], out [2] =  k * (self [4] * self [8] - self [7] * self [5]), -k * (self [3] * self [8] - self [6] * self [5]),  k * (self [3] * self [7] - self [6] * self [4]) 
	out [3], out [4], out [5] = -k * (self [1] * self [8] - self [7] * self [2]),  k * (self [0] * self [8] - self [6] * self [2]), -k * (self [0] * self [7] - self [6] * self [1]) 
	out [6], out [7], out [8] =  k * (self [1] * self [5] - self [4] * self [2]), -k * (self [0] * self [5] - self [3] * self [2]),  k * (self [0] * self [4] - self [3] * self [1]) 
	return out
end

function Cat.LinearAlgebra.Matrix3x3d.Transpose (self, out)
	local out = out or Cat.LinearAlgebra.Matrix3x3d ()
	out [0], out [4], out [8] = self [0], self [4], self [8]
	out [1], out [3] = self [3], self [1]
	out [2], out [6] = self [6], self [2]
	out [5], out [7] = self [7], self [5]
	return out
end

self.Determinant = Cat.LinearAlgebra.Matrix3x3d.Determinant
self.Invert      = Cat.LinearAlgebra.Matrix3x3d.Invert
self.Transpose   = Cat.LinearAlgebra.Matrix3x3d.Transpose

-- Rows and columns
function Cat.LinearAlgebra.Matrix3x3d.GetColumn (self, column, out)
	local out = out or Cat.LinearAlgebra.Vector3d ()
	out [0], out [1], out [2] = self [0 + column], self [3 + column], self [6 + column]
	return out
end

function Cat.LinearAlgebra.Matrix3x3d.GetRow (self, row, out)
	local out = out or Cat.LinearAlgebra.Vector3d ()
	out [0], out [1], out [2] = self [0 + row * 3], self [1 + row * 3], self [2 + row * 3]
	return out
end

function Cat.LinearAlgebra.Matrix3x3d.SetColumn (self, column, v)
	self [0 + column], self [3 + column], self [6 + column] = v [0], v [1], v [2]
	return self
end

function Cat.LinearAlgebra.Matrix3x3d.SetRow (self, row, v)
	self [0 + row * 3], self [1 + row * 3], self [2 + row * 3] = v [0], v [1], v [2]
	return self
end

self.GetColumn = Cat.LinearAlgebra.Matrix3x3d.GetColumn
self.GetRow    = Cat.LinearAlgebra.Matrix3x3d.GetRow
self.SetColumn = Cat.LinearAlgebra.Matrix3x3d.SetColumn
self.SetRow    = Cat.LinearAlgebra.Matrix3x3d.SetRow

-- Utility
function Cat.LinearAlgebra.Matrix3x3d.Clone (self, out)
	local out = out or Cat.LinearAlgebra.Matrix3x3d ()
	out [0], out [1], out [2] = self [0], self [1], self [2]
	out [3], out [4], out [5] = self [3], self [4], self [5]
	out [6], out [7], out [8] = self [6], self [7], self [8]
	return out
end

function Cat.LinearAlgebra.Matrix3x3d.ToString (self)
	return "[" .. self [0] .. ", " .. self [1] .. ", " .. self [2] .. "]\n" ..
	       "[" .. self [3] .. ", " .. self [4] .. ", " .. self [5] .. "]\n" ..
	       "[" .. self [6] .. ", " .. self [7] .. ", " .. self [8] .. "]"
end

self.Clone    = Cat.LinearAlgebra.Matrix3x3d.Clone
self.ToString = Cat.LinearAlgebra.Matrix3x3d.ToString
