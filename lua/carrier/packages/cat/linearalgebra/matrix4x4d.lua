local self = {}
Cat.LinearAlgebra.Matrix4x4d = Class(self)

function Cat.LinearAlgebra.Matrix4x4d.Zero(out)
	local out = out or Cat.LinearAlgebra.Matrix4x4d()
	out[ 0], out[ 1], out[ 2], out[ 3] = 0, 0, 0, 0
	out[ 4], out[ 5], out[ 6], out[ 7] = 0, 0, 0, 0
	out[ 8], out[ 9], out[10], out[11] = 0, 0, 0, 0
	out[12], out[13], out[14], out[15] = 0, 0, 0, 0
	return out
end

function Cat.LinearAlgebra.Matrix4x4d.Identity(out)
	local out = out or Cat.LinearAlgebra.Matrix4x4d()
	out[ 0], out[ 1], out[ 2], out[ 3] = 1, 0, 0, 0
	out[ 4], out[ 5], out[ 6], out[ 7] = 0, 1, 0, 0
	out[ 8], out[ 9], out[10], out[11] = 0, 0, 1, 0
	out[12], out[13], out[14], out[15] = 0, 0, 0, 1
	return out
end

function Cat.LinearAlgebra.Matrix4x4d.FromMatrix3x3d(m, out)
	local out = out or Cat.LinearAlgebra.Matrix4x4d()
	out[ 0], out[ 1], out[ 2], out[ 3] = m[0], m[1], m[2], 0
	out[ 4], out[ 5], out[ 6], out[ 7] = m[3], m[4], m[5], 0
	out[ 8], out[ 9], out[10], out[11] = m[6], m[7], m[8], 0
	out[12], out[13], out[14], out[15] =     0,     0,     0, 1
	return out
end

function Cat.LinearAlgebra.Matrix4x4d.FromAffineMatrix3x3d(m, out)
	local out = out or Cat.LinearAlgebra.Matrix4x4d()
	out[ 0], out[ 1], out[ 2], out[ 3] = m[0], m[1], 0, m[2]
	out[ 4], out[ 5], out[ 6], out[ 7] = m[3], m[4], 0, m[5]
	out[ 8], out[ 9], out[10], out[11] =     0,     0, 1,     0
	out[12], out[13], out[14], out[15] = m[6], m[7], 0, m[8]
	return out
end

function Cat.LinearAlgebra.Matrix4x4d.ToMatrix3x3d(self, out)
	local out = out or Cat.LinearAlgebra.Matrix3x3d()
	out[0], out[1], out[2] = m[0], m[1], m[ 2]
	out[3], out[4], out[5] = m[4], m[5], m[ 6]
	out[6], out[7], out[8] = m[8], m[9], m[10]
	return out
end

function Cat.LinearAlgebra.Matrix4x4d.ToAffineMatrix3x3d(self, out)
	local out = out or Cat.LinearAlgebra.Matrix3x3d()
	out[0], out[1], out[2] = m[ 0], m[ 1], m[ 3]
	out[3], out[4], out[5] = m[ 4], m[ 5], m[ 7]
	out[6], out[7], out[8] = m[12], m[13], m[15]
	return out
end

function self:ctor(m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33)
	self[ 0], self[ 1], self[ 2], self[ 3] = m00, m01, m02, m03
	self[ 4], self[ 5], self[ 6], self[ 7] = m10, m11, m12, m13
	self[ 8], self[ 9], self[10], self[11] = m20, m21, m22, m23
	self[12], self[13], self[14], self[15] = m30, m31, m32, m33
end

function Cat.LinearAlgebra.Matrix4x4d.Equals(a, b)
	return a[ 0] == b[ 0] and a[ 1] == b[ 1] and a[ 2] == b[ 2] and a[ 3] == b[ 3] and
	       a[ 4] == b[ 4] and a[ 5] == b[ 5] and a[ 6] == b[ 6] and a[ 7] == b[ 7] and
	       a[ 8] == b[ 8] and a[ 9] == b[ 9] and a[10] == b[10] and a[11] == b[11] and
	       a[12] == b[12] and a[13] == b[13] and a[14] == b[14] and a[15] == b[15]
end

self.ToMatrix3x3d = Cat.LinearAlgebra.Matrix3x3d.ToMatrix3x3d
self.Equals       = Cat.LinearAlgebra.Matrix4x4d.Equals

-- Elements
function Cat.LinearAlgebra.Matrix4x4d.Get(self, y, x)
	local i = y * 4 + x
	return self[i]
end

function Cat.LinearAlgebra.Matrix4x4d.Set(self, y, x, value)
	local i = y * 4 + x
	self[i] = value
	return self
end

self.Get = Cat.LinearAlgebra.Matrix4x4d.Get
self.Set = Cat.LinearAlgebra.Matrix4x4d.Set

-- Arithmetic
function Cat.LinearAlgebra.Matrix4x4d.Add(a, b, out)
	local out = out or Cat.LinearAlgebra.Matrix4x4d()
	out[ 0], out[ 1], out[ 2], out[ 3] = a[ 0] + b[ 0], a[ 1] + b[ 1], a[ 2] + b[ 2], a[ 3] + b[ 3]
	out[ 4], out[ 5], out[ 6], out[ 7] = a[ 4] + b[ 4], a[ 5] + b[ 5], a[ 6] + b[ 6], a[ 7] + b[ 7]
	out[ 8], out[ 9], out[10], out[11] = a[ 8] + b[ 8], a[ 9] + b[ 9], a[10] + b[10], a[11] + b[11]
	out[12], out[13], out[14], out[15] = a[12] + b[12], a[13] + b[13], a[14] + b[14], a[15] + b[15]
	return out
end

function Cat.LinearAlgebra.Matrix4x4d.Subtract(a, b, out)
	local out = out or Cat.LinearAlgebra.Matrix4x4d()
	out[ 0], out[ 1], out[ 2], out[ 3] = a[ 0] - b[ 0], a[ 1] - b[ 1], a[ 2] - b[ 2], a[ 3] - b[ 3]
	out[ 4], out[ 5], out[ 6], out[ 7] = a[ 4] - b[ 4], a[ 5] - b[ 5], a[ 6] - b[ 6], a[ 7] - b[ 7]
	out[ 8], out[ 9], out[10], out[11] = a[ 8] - b[ 8], a[ 9] - b[ 9], a[10] - b[10], a[11] - b[11]
	out[12], out[13], out[14], out[15] = a[12] - b[12], a[13] - b[13], a[14] - b[14], a[15] - b[15]
	return out
end

function Cat.LinearAlgebra.Matrix4x4d.Negate(a, out)
	local out = out or Cat.LinearAlgebra.Matrix4x4d()
	out[ 0], out[ 1], out[ 2], out[ 3] = -a[ 0], -a[ 1], -a[ 2], -a[ 3]
	out[ 4], out[ 5], out[ 6], out[ 7] = -a[ 4], -a[ 5], -a[ 6], -a[ 7]
	out[ 8], out[ 9], out[10], out[11] = -a[ 8], -a[ 9], -a[10], -a[11]
	out[12], out[13], out[14], out[15] = -a[12], -a[13], -a[14], -a[15]
	return out
end

function Cat.LinearAlgebra.Matrix4x4d.ScalarMultiply(a, k, out)
	local out = out or Cat.LinearAlgebra.Matrix4x4d()
	out[ 0], out[ 1], out[ 2], out[ 3] = a[ 0] * k, a[ 1] * k, a[ 2] * k, a[ 3] * k
	out[ 4], out[ 5], out[ 6], out[ 7] = a[ 4] * k, a[ 5] * k, a[ 6] * k, a[ 7] * k
	out[ 8], out[ 9], out[10], out[11] = a[ 8] * k, a[ 9] * k, a[10] * k, a[11] * k
	out[12], out[13], out[14], out[15] = a[12] * k, a[13] * k, a[14] * k, a[15] * k
	return out
end

function Cat.LinearAlgebra.Matrix4x4d.ScalarDivide(a, k, out)
	local out = out or Cat.LinearAlgebra.Matrix4x4d()
	out[ 0], out[ 1], out[ 2], out[ 3] = a[ 0] / k, a[ 1] / k, a[ 2] / k, a[ 3] / k
	out[ 4], out[ 5], out[ 6], out[ 7] = a[ 4] / k, a[ 5] / k, a[ 6] / k, a[ 7] / k
	out[ 8], out[ 9], out[10], out[11] = a[ 8] / k, a[ 9] / k, a[10] / k, a[11] / k
	out[12], out[13], out[14], out[15] = a[12] / k, a[13] / k, a[14] / k, a[15] / k
	return out
end

self.Add            = Cat.LinearAlgebra.Matrix4x4d.Add
self.Subtract       = Cat.LinearAlgebra.Matrix4x4d.Subtract
self.Negate         = Cat.LinearAlgebra.Matrix4x4d.Negate
self.ScalarMultiply = Cat.LinearAlgebra.Matrix4x4d.ScalarMultiply
self.ScalarDivide   = Cat.LinearAlgebra.Matrix4x4d.ScalarDivide

-- Products
function Cat.LinearAlgebra.Matrix4x4d.MatrixMultiply(a, b, out)
	local out = out or Cat.LinearAlgebra.Matrix4x4d()
	out[ 0], out[ 1], out[ 2], out[ 3] = a[ 0] * b[0] + a[ 1] * b[4] + a[ 2] * b[8] + a[ 3] * b[12], a[ 0] * b[1] + a[ 1] * b[5] + a[ 2] * b[9] + a[ 3] * b[13], a[ 0] * b[2] + a[ 1] * b[6] + a[ 2] * b[10] + a[ 3] * b[14], a[ 0] * b[3] + a[ 1] * b[7] + a[ 2] * b[11] + a[ 3] * b[15]
	out[ 4], out[ 5], out[ 6], out[ 7] = a[ 4] * b[0] + a[ 5] * b[4] + a[ 6] * b[8] + a[ 7] * b[12], a[ 4] * b[1] + a[ 5] * b[5] + a[ 6] * b[9] + a[ 7] * b[13], a[ 4] * b[2] + a[ 5] * b[6] + a[ 6] * b[10] + a[ 7] * b[14], a[ 4] * b[3] + a[ 5] * b[7] + a[ 6] * b[11] + a[ 7] * b[15]
	out[ 8], out[ 9], out[10], out[11] = a[ 8] * b[0] + a[ 9] * b[4] + a[10] * b[8] + a[11] * b[12], a[ 8] * b[1] + a[ 9] * b[5] + a[10] * b[9] + a[11] * b[13], a[ 8] * b[2] + a[ 9] * b[6] + a[10] * b[10] + a[11] * b[14], a[ 8] * b[3] + a[ 9] * b[7] + a[10] * b[11] + a[11] * b[15]
	out[12], out[13], out[14], out[15] = a[12] * b[0] + a[13] * b[4] + a[14] * b[8] + a[15] * b[12], a[12] * b[1] + a[13] * b[5] + a[14] * b[9] + a[15] * b[13], a[12] * b[2] + a[13] * b[6] + a[14] * b[10] + a[15] * b[14], a[12] * b[3] + a[13] * b[7] + a[14] * b[11] + a[15] * b[15]
	return out
end

Cat.LinearAlgebra.Matrix4x4d.Multiply = Cat.LinearAlgebra.Matrix4x4d.MatrixMultiply

function Cat.LinearAlgebra.Matrix4x4d.VectorMultiply(self, v, out)
	local out = out or Cat.LinearAlgebra.Vector4d()
	out[0] = self[ 0] * v[0] + self[ 1] * v[1] + self[ 2] * v[2] + self[ 3] * v[3]
	out[1] = self[ 4] * v[0] + self[ 5] * v[1] + self[ 6] * v[2] + self[ 7] * v[3]
	out[2] = self[ 8] * v[0] + self[ 9] * v[1] + self[10] * v[2] + self[11] * v[3]
	out[3] = self[12] * v[0] + self[13] * v[1] + self[14] * v[2] + self[15] * v[3]
	return out
end

self.MatrixMultiply = Cat.LinearAlgebra.Matrix4x4d.MatrixMultiply
self.Multiply       = Cat.LinearAlgebra.Matrix4x4d.Multiply
self.VectorMultiply = Cat.LinearAlgebra.Matrix4x4d.VectorMultiply

-- Matrix operations
function Cat.LinearAlgebra.Matrix4x4d.Determinant(self)
	return   self[0] * (  self[ 5] * (self[10] * self[15] - self[14] * self[11])
	                     - self[ 6] * (self[ 9] * self[15] - self[13] * self[11])
	                     + self[ 7] * (self[ 9] * self[14] - self[13] * self[10]))
	       - self[1] * (  self[ 4] * (self[10] * self[15] - self[14] * self[11])
	                     - self[ 6] * (self[ 8] * self[15] - self[12] * self[11])
	                     + self[ 7] * (self[ 8] * self[14] - self[12] * self[10]))
	       + self[2] * (  self[ 4] * (self[ 9] * self[15] - self[13] * self[11])
	                     - self[ 5] * (self[ 8] * self[15] - self[12] * self[11])
	                     + self[ 7] * (self[ 8] * self[13] - self[12] * self[ 9]))
	       - self[3] * (  self[ 4] * (self[ 9] * self[14] - self[13] * self[10])
	                     - self[ 5] * (self[ 8] * self[14] - self[12] * self[10])
                         + self[ 6] * (self[ 8] * self[13] - self[12] * self[ 9]))
end

local Cat_LinearAlgebra_Matrix4x4d_Determinant = Cat.LinearAlgebra.Matrix4x4d.Determinant
function Cat.LinearAlgebra.Matrix4x4d.Invert(self, out)
	local out = out or Cat.LinearAlgebra.Matrix4x4d()
	local k = 1 / Cat_LinearAlgebra_Matrix4x4d_Determinant(self)
	
	local m00, m01, m02, m03 = self[ 0], self[ 1], self[ 2], self[ 3]
	local m10, m11, m12, m13 = self[ 4], self[ 5], self[ 6], self[ 7]
	local m20, m21, m22, m23 = self[ 8], self[ 9], self[10], self[11]
	local m30, m31, m32, m33 = self[12], self[13], self[14], self[15]
	
	local m22m33m32m23 = m22 * m33 - m32 * m23
	local m21m33m31m23 = m21 * m33 - m31 * m23
	local m21m32m31m22 = m21 * m32 - m31 * m22
	local m20m33m30m23 = m20 * m33 - m30 * m23
	local m20m32m30m22 = m20 * m32 - m30 * m22
	local m20m31m30m21 = m20 * m31 - m30 * m21
	out[ 0] =  k * (m11 * m22m33m32m23 - m12 * m21m33m31m23 + m13 * m21m32m31m22)
	out[ 1] = -k * (m01 * m22m33m32m23 - m02 * m21m33m31m23 + m03 * m21m32m31m22)
	out[ 4] = -k * (m10 * m22m33m32m23 - m12 * m20m33m30m23 + m13 * m20m32m30m22)
	out[ 5] =  k * (m00 * m22m33m32m23 - m02 * m20m33m30m23 + m03 * m20m32m30m22)
	out[ 8] =  k * (m10 * m21m33m31m23 - m11 * m20m33m30m23 + m13 * m20m31m30m21)
	out[ 9] = -k * (m00 * m21m33m31m23 - m01 * m20m33m30m23 + m03 * m20m31m30m21)
	out[12] = -k * (m10 * m21m32m31m22 - m11 * m20m32m30m22 + m12 * m20m31m30m21)
	out[13] =  k * (m00 * m21m32m31m22 - m01 * m20m32m30m22 + m02 * m20m31m30m21)
	
	local m12m33m32m13 = m12 * m33 - m32 * m13
	local m11m33m31m13 = m11 * m33 - m31 * m13
	local m11m32m31m12 = m11 * m32 - m31 * m12
	local m10m33m30m13 = m10 * m33 - m30 * m13
	local m10m32m30m12 = m10 * m32 - m30 * m12
	local m10m31m30m11 = m10 * m31 - m30 * m11
	out[ 2] =  k * (m01 * m12m33m32m13 - m02 * m11m33m31m13 + m03 * m11m32m31m12)
	out[ 6] = -k * (m00 * m12m33m32m13 - m02 * m10m33m30m13 + m03 * m10m32m30m12)
	out[10] =  k * (m00 * m11m33m31m13 - m01 * m10m33m30m13 + m03 * m10m31m30m11)
	out[14] = -k * (m00 * m11m32m31m12 - m01 * m10m32m30m12 + m02 * m10m31m30m11)
	
	local m12m23m22m13 = m12 * m23 - m22 * m13
	local m11m23m21m13 = m11 * m23 - m21 * m13
	local m11m22m21m12 = m11 * m22 - m21 * m12
	local m10m23m20m13 = m10 * m23 - m20 * m13
	local m10m22m20m12 = m10 * m22 - m20 * m12
	local m10m21m20m11 = m10 * m21 - m20 * m11
	out[ 3] = -k * (m01 * m12m23m22m13 - m02 * m11m23m21m13 + m03 * m11m22m21m12)
	out[ 7] =  k * (m00 * m12m23m22m13 - m02 * m10m23m20m13 + m03 * m10m22m20m12)
	out[11] = -k * (m00 * m11m23m21m13 - m01 * m10m23m20m13 + m03 * m10m21m20m11)
	out[15] =  k * (m00 * m11m22m21m12 - m01 * m10m22m20m12 + m02 * m10m21m20m11)
	
	return out
end

function Cat.LinearAlgebra.Matrix4x4d.Transpose(self, out)
	local out = out or Cat.LinearAlgebra.Matrix4x4d()
	out[0], out[5], out[9], out[15] = self[0], self[5], self[9], self[15]
	out[1], out[3] = self[3], self[1]
	out[2], out[6] = self[6], self[2]
	out[5], out[7] = self[7], self[5]
	return out
end

self.Determinant = Cat.LinearAlgebra.Matrix4x4d.Determinant
self.Invert      = Cat.LinearAlgebra.Matrix4x4d.Invert
self.Transpose   = Cat.LinearAlgebra.Matrix4x4d.Transpose

-- Rows and columns
function Cat.LinearAlgebra.Matrix4x4d.GetColumn(self, column, out)
	local out = out or Cat.LinearAlgebra.Vector4d()
	out[0], out[1], out[2], out[3] = self[0 + column], self[4 + column], self[8 + column], self[12 + column]
	return out
end

function Cat.LinearAlgebra.Matrix4x4d.GetRow(self, row, out)
	local out = out or Cat.LinearAlgebra.Vector4d()
	out[0], out[1], out[2], out[3] = self[0 + row * 4], self[1 + row * 4], self[2 + row * 4], self[3 + row * 4]
	return out
end

function Cat.LinearAlgebra.Matrix4x4d.SetColumn(self, column, v)
	self[0 + column], self[4 + column], self[8 + column], self[12 + column] = v[0], v[1], v[2], v[3]
	return self
end

function Cat.LinearAlgebra.Matrix4x4d.SetRow(self, row, v)
	self[0 + row * 4], self[1 + row * 4], self[2 + row * 4], self[3 + row * 4] = v[0], v[1], v[2], v[3]
	return self
end

self.GetColumn = Cat.LinearAlgebra.Matrix4x4d.GetColumn
self.GetRow    = Cat.LinearAlgebra.Matrix4x4d.GetRow
self.SetColumn = Cat.LinearAlgebra.Matrix4x4d.SetColumn
self.SetRow    = Cat.LinearAlgebra.Matrix4x4d.SetRow

-- Utility
function Cat.LinearAlgebra.Matrix4x4d.Clone(self, out)
	local out = out or Cat.LinearAlgebra.Matrix4x4d()
	out[ 0], out[ 1], out[ 2], out[ 3] = self[ 0], self[ 1], self[ 2], self[ 3]
	out[ 4], out[ 5], out[ 6], out[ 7] = self[ 4], self[ 5], self[ 6], self[ 7]
	out[ 8], out[ 9], out[10], out[11] = self[ 8], self[ 9], self[10], self[11]
	out[12], out[13], out[14], out[15] = self[12], self[13], self[14], self[15]
	return out
end

function Cat.LinearAlgebra.Matrix4x4d.ToString(self)
	return "[" .. self[ 0] .. ", " .. self[ 1] .. ", " .. self[ 2] .. ", " .. self[ 3] .. "]\n" ..
	       "[" .. self[ 4] .. ", " .. self[ 5] .. ", " .. self[ 6] .. ", " .. self[ 7] .. "]\n" ..
	       "[" .. self[ 8] .. ", " .. self[ 9] .. ", " .. self[10] .. ", " .. self[11] .. "]\n" ..
	       "[" .. self[12] .. ", " .. self[13] .. ", " .. self[14] .. ", " .. self[15] .. "]"
end

self.Clone    = Cat.LinearAlgebra.Matrix4x4d.Clone
self.ToString = Cat.LinearAlgebra.Matrix4x4d.ToString
