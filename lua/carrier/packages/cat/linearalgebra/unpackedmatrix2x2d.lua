Cat.UnpackedMatrix2x2d = Table.Callable (
	function (m00, m01, m10, m11)
		return m00, m01,
		       m10, m11
	end
)

function Cat.UnpackedMatrix2x2d.Identity ()
	return 1, 0,
	       0, 1
end

function Cat.UnpackedMatrix2x2d.Zero ()
	return 0, 0,
	       0, 0
end

function Cat.UnpackedMatrix2x2d.Equals (a00, a01, a10, a11, b00, b01, b10, b11)
	return a00 == b00 and a01 == b01 and
	       a10 == b10 and a11 == b11
end

-- Elements
function Cat.UnpackedMatrix2x2d.Get (m00, m01, m10, m11, y, x)
	local i = y * 2 + x
	if     i == 0 then return m00
	elseif i == 1 then return m01
	elseif i == 2 then return m10
	else               return m11 end
end

function Cat.UnpackedMatrix2x2d.Set (m00, m01, m10, m11, y, x, value)
	local i = y * 2 + x
	if     i == 0 then m00 = value
	elseif i == 1 then m01 = value
	elseif i == 2 then m10 = value
	else               m11 = value end
	
	return m00, m01,
	       m10, m11
end

-- Arithmetic
function Cat.UnpackedMatrix2x2d.Add (a00, a01, a10, a11, b00, b01, b10, b11)
	return a00 + b00, a01 + b01,
	       a10 + b10, a11 + b11
end

function Cat.UnpackedMatrix2x2d.Subtract (a00, a01, a10, a11, b00, b01, b10, b11)
	return a00 - b00, a01 - b01,
	       a10 - b10, a11 - b11
end

function Cat.UnpackedMatrix2x2d.Negate (m00, m01, m10, m11)
	return -m00, -m01,
	       -m10, -m11
end

function Cat.UnpackedMatrix2x2d.ScalarMultiply (m00, m01, m10, m11, k)
	return m00 * k, m01 * k,
	       m10 * k, m11 * k
end

function Cat.UnpackedMatrix2x2d.ScalarDivide (m00, m01, m10, m11, k)
	return m00 / k, m01 / k,
	       m10 / k, m11 / k
end

-- Products
function Cat.UnpackedMatrix2x2d.Multiply (a00, a01, a10, a11, b00, b01, b10, b11)
	return a00 * b00 + a01 * b10, a00 * b01 + a01 * b11,
	       a10 * b00 + a11 * b10, a10 * b01 + a11 * b11
end

Cat.UnpackedMatrix2x2d.MatrixMultiply = Cat.UnpackedMatrix2x2d.Multiply

function Cat.UnpackedMatrix2x2d.VectorMultiply (m00, m01, m10, m11, v0, v1)
	return m00 * v0 + m01 * v1,
	       m10 * v0 + m11 * v1
end

-- Matrix operations
function Cat.UnpackedMatrix2x2d.Determinant (m00, m01, m10, m11)
	return m00 * m11 - m01 * m10
end

local Cat_UnpackedMatrix2x2d_Determinant = Cat.UnpackedMatrix2x2d.Determinant
function Cat.UnpackedMatrix2x2d.Invert (m00, m01, m10, m11)
	local k = 1 / Cat_UnpackedMatrix2x2d_Determinant (m00, m01, m10, m11)
	return  k * m11, -k * m10,
	       -k * m01,  k * m00
end

function Cat.UnpackedMatrix2x2d.Transpose (m00, m01, m10, m11)
	return m00, m10,
	       m01, m11
end

-- Rows and columns
function Cat.UnpackedMatrix2x2d.GetColumn (m00, m01, m10, m11, column)
	if column == 0 then return m00, m10
	else                return m01, m11 end
end

function Cat.UnpackedMatrix2x2d.GetRow (m00, m01, m10, m11, row)
	if row == 0 then return m00, m01
	else             return m10, m11 end
end

function Cat.UnpackedMatrix2x2d.SetColumn (m00, m01, m10, m11, column, v0, v1)
	if column == 0 then m00, m10 = v0, v1
	else                m01, m11 = v0, v1 end
	
	return m00, m01,
	       m10, m11
end

function Cat.UnpackedMatrix2x2d.SetRow (m00, m01, m10, m11, row, v0, v1)
	if row == 0 then m00, m01 = v0, v1
	else             m10, m11 = v0, v1 end
	
	return m00, m01,
	       m10, m11
end

-- Utility
function Cat.UnpackedMatrix2x2d.ToString (m00, m01, m10, m11)
	return "[" .. m00 .. ", " .. m01 .. "]\n" ..
	       "[" .. m10 .. ", " .. m11 .. "]"
end
