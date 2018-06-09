Cat.LinearAlgebra.UnpackedMatrix3x3d = Table.Callable (
	function (m00, m01, m02, m10, m11, m12, m20, m21, m22)
		return m00, m01, m02,
		       m10, m11, m12,
		       m20, m21, m22
	end
)

function Cat.LinearAlgebra.UnpackedMatrix3x3d.Identity ()
	return 1, 0, 0,
	       0, 1, 0,
	       0, 0, 1
end

function Cat.LinearAlgebra.UnpackedMatrix3x3d.Zero ()
	return 0, 0, 0,
	       0, 0, 0,
	       0, 0, 0
end

function Cat.LinearAlgebra.UnpackedMatrix3x3d.FromMatrix2x2d (m00, m01, m10, m11)
	return m00, m01, 0,
	       m10, m11, 0,
	         0,   0, 1
end

function Cat.LinearAlgebra.UnpackedMatrix3x3d.ToMatrix2x2d (m00, m01, m02, m10, m11, m12, m20, m21, m22)
	return m00, m01,
	       m10, m11
end

function Cat.LinearAlgebra.UnpackedMatrix3x3d.Equals (a00, a01, a02, a10, a11, a12, a20, a21, a22, b00, b01, b02, b10, b11, b12, b20, b21, b22)
	return a00 == b00 and a01 == b01 and a02 == b02 and
	       a10 == b10 and a11 == b11 and a12 == b12 and
	       a20 == b20 and a21 == b21 and a22 == b22
end

-- Elements
function Cat.LinearAlgebra.UnpackedMatrix3x3d.Get (m00, m01, m02, m10, m11, m12, m20, m21, m22, y, x)
	local i = y * 3 + x
	if     i == 0 then return m00
	elseif i == 1 then return m01
	elseif i == 2 then return m02
	elseif i == 3 then return m10
	elseif i == 4 then return m11
	elseif i == 5 then return m12
	elseif i == 6 then return m20
	elseif i == 7 then return m21
	else               return m22 end
end

function Cat.LinearAlgebra.UnpackedMatrix3x3d.Set (m00, m01, m02, m10, m11, m12, m20, m21, m22, y, x, value)
	local i = y * 3 + x
	if     i == 0 then m00 = value
	elseif i == 1 then m01 = value
	elseif i == 2 then m02 = value
	elseif i == 3 then m10 = value
	elseif i == 4 then m11 = value
	elseif i == 5 then m12 = value
	elseif i == 6 then m20 = value
	elseif i == 7 then m21 = value
	else               m22 = value end
	
	return m00, m01, m02,
	       m10, m11, m12,
	       m20, m21, m22
end

-- Arithmetic
function Cat.LinearAlgebra.UnpackedMatrix3x3d.Add (a00, a01, a02, a10, a11, a12, a20, a21, a22, b00, b01, b02, b10, b11, b12, b20, b21, b22)
	return a00 + b00, a01 + b01, a02 + b02,
	       a10 + b10, a11 + b11, a12 + b12,
	       a20 + b20, a21 + b21, a22 + b22
end

function Cat.LinearAlgebra.UnpackedMatrix3x3d.Subtract (a00, a01, a02, a10, a11, a12, a20, a21, a22, b00, b01, b02, b10, b11, b12, b20, b21, b22)
	return a00 - b00, a01 - b01, a02 - b02,
	       a10 - b10, a11 - b11, a12 - b12,
	       a20 - b10, a21 - b21, a22 - b22
end

function Cat.LinearAlgebra.UnpackedMatrix3x3d.Negate (m00, m01, m02, m10, m11, m12, m20, m21, m22)
	return -m00, -m01, -m02,
	       -m10, -m11, -m12,
	       -m20, -m21, -m22
end

function Cat.LinearAlgebra.UnpackedMatrix3x3d.ScalarMultiply (m00, m01, m02, m10, m11, m12, m20, m21, m22, k)
	return m00 * k, m01 * k, m02 * k,
	       m10 * k, m11 * k, m12 * k,
	       m20 * k, m21 * k, m22 * k
end

function Cat.LinearAlgebra.UnpackedMatrix3x3d.ScalarDivide (m00, m01, m02, m10, m11, m12, m20, m21, m22, k)
	return m00 / k, m01 / k, m02 / k,
	       m10 / k, m11 / k, m12 / k,
	       m20 / k, m21 / k, m22 / k
end

-- Products
function Cat.LinearAlgebra.UnpackedMatrix3x3d.MatrixMultiply (a00, a01, a02, a10, a11, a12, a20, a21, a22, b00, b01, b02, b10, b11, b12, b20, b21, b22)
	return a00 * b00 + a01 * b10 + a02 * b20, a00 * b01 + a01 * b11 + a02 * b21, a00 * b02 + a01 * b12 + a02 * b22,
	       a10 * b00 + a11 * b10 + a12 * b20, a10 * b01 + a11 * b11 + a12 * b21, a10 * b02 + a11 * b12 + a12 * b22,
	       a20 * b00 + a21 * b10 + a22 * b20, a20 * b01 + a21 * b11 + a22 * b21, a20 * b02 + a21 * b12 + a22 * b22
end

Cat.LinearAlgebra.UnpackedMatrix3x3d.Multiply = Cat.LinearAlgebra.UnpackedMatrix3x3d.MatrixMultiply

function Cat.LinearAlgebra.UnpackedMatrix3x3d.VectorMultiply (m00, m01, m02, m10, m11, m12, m20, m21, m22, v0, v1, v2)
	return m00 * v0 + m01 * v1 + m02 * v2,
	       m10 * v0 + m11 * v1 + m12 * v2,
	       m20 * v0 + m21 * v1 + m22 * v2
end

-- Matrix operations
function Cat.LinearAlgebra.UnpackedMatrix3x3d.Determinant (m00, m01, m02, m10, m11, m12, m20, m21, m22)
	return   m00 * (m11 * m22 - m21 * m12)
	       - m10 * (m01 * m22 - m21 * m02)
	       + m20 * (m01 * m12 - m11 * m02)
end

local Cat_LinearAlgebra_UnpackedMatrix3x3d_Determinant = Cat.LinearAlgebra.UnpackedMatrix3x3d.Determinant
function Cat.LinearAlgebra.UnpackedMatrix3x3d.Invert (m00, m01, m02, m10, m11, m12, m20, m21, m22)
	local k = 1 / Cat_LinearAlgebra_UnpackedMatrix3x3d_Determinant (m00, m01, m02, m10, m11, m12, m20, m21, m22)
	return  k * (m11 * m22 - m21 * m12), -k * (m10 * m22 - m20 * m12),  k * (m10 * m21 - m20 * m11),
	       -k * (m01 * m22 - m21 * m02),  k * (m00 * m22 - m20 * m02), -k * (m00 * m21 - m20 * m01),
	        k * (m01 * m12 - m11 * m02), -k * (m00 * m12 - m10 * m02),  k * (m00 * m11 - m10 * m01)
end

function Cat.LinearAlgebra.UnpackedMatrix3x3d.Transpose (m00, m01, m02, m10, m11, m12, m20, m21, m22)
	return m00, m10, m20,
	       m01, m11, m21,
	       m02, m12, m22
end

-- Rows and columns
function Cat.LinearAlgebra.UnpackedMatrix3x3d.GetColumn (m00, m01, m02, m10, m11, m12, m20, m21, m22, column)
	if     column == 0 then return m00, m10, m20
	elseif column == 1 then return m01, m11, m21
	else                    return m02, m12, m22 end
end

function Cat.LinearAlgebra.UnpackedMatrix3x3d.GetRow (m00, m01, m02, m10, m11, m12, m20, m21, m22, row)
	if     row == 0 then return m00, m01, m02
	elseif row == 1 then return m10, m11, m12
	else                 return m20, m21, m22 end
end

function Cat.LinearAlgebra.UnpackedMatrix3x3d.SetColumn (m00, m01, m02, m10, m11, m12, m20, m21, m22, column, v0, v1)
	if     column == 0 then m00, m10, m20 = v0, v1, v2
	elseif column == 1 then m01, m11, m21 = v0, v1, v2
	else                    m02, m12, m22 = v0, v1, v2 end
	
	return m00, m01, m02,
	       m10, m11, m12,
	       m20, m21, m22
end

function Cat.LinearAlgebra.UnpackedMatrix3x3d.SetRow (m00, m01, m02, m10, m11, m12, m20, m21, m22, row, v0, v1)
	if     row == 0 then m00, m01, m02 = v0, v1, v2
	elseif row == 1 then m10, m11, m12 = v0, v1, v2
	else                 m20, m21, m22 = v0, v1, v2 end
	
	return m00, m01, m02,
	       m10, m11, m12,
	       m20, m21, m22
end

-- Utility
function Cat.LinearAlgebra.UnpackedMatrix3x3d.ToString (m00, m01, m02, m10, m11, m12, m20, m21, m22)
	return "[" .. m00 .. ", " .. m01 .. ", " .. m02 .. "]\n" ..
	       "[" .. m10 .. ", " .. m11 .. ", " .. m12 .. "]\n" ..
	       "[" .. m20 .. ", " .. m21 .. ", " .. m22 .. "]"
end
