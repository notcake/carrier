local tostring   = tostring

local math_atan2 = math.atan2
local math_cos   = math.cos
local math_exp   = math.exp
local math_log   = math.log
local math_sin   = math.sin
local math_sqrt  = math.sqrt

Cat.UnpackedComplex = Table.Callable(
	function(a, b)
		return a, b
	end
)

-- Arithmetic
function Cat.UnpackedComplex.Add(ar, ai, br, bi)
	return ar + br, ai + bi
end

function Cat.UnpackedComplex.Subtract(ar, ai, br, bi)
	return ar - br, ai - bi
end

function Cat.UnpackedComplex.Multiply(ar, ai, br, bi)
	return ar * br - ai * bi, ar * bi + ai * br
end

function Cat.UnpackedComplex.Divide(ar, ai, br, bi)
	-- ar + i ai   (ar + i ai)(br - i bi)
	-- --------- = ----------------------
	-- br + i bi   (br + i bi)(br - i bi)
	--
	--             ar br + ai bi + i(ai br - ar bi)
	--           = --------------------------------
	--                     br br + bi bi
	local k = 1 / (br * br + bi * bi)
	return k * (ar * br + ai * bi), k * (ai * br - ar * bi)
end

function Cat.UnpackedComplex.Negate(ar, ai)
	return -ar, -ai
end

function Cat.UnpackedComplex.Scale(ar, ai, k)
	return ar * k, ai * k
end

function Cat.UnpackedComplex.Exponentiate(ar, ai, br, bi)
	return Cat.UnpackedComplex.Exp(Cat.UnpackedComplex.Multiply(br, bi, Cat.UnpackedComplex.Log(ar, ai)))
end

-- Other
function Cat.UnpackedComplex.Abs(ar, ai)
	return math_sqrt(ar * ar + ai * ai)
end

function Cat.UnpackedComplex.Arg(ar, ai)
	return math_atan2(ai, ar)
end

function Cat.UnpackedComplex.Conjugate(ar, ai)
	return ar, -ai
end

function Cat.UnpackedComplex.Exp(ar, ai)
	-- e^(ar + i ai) = e^ar e^(i ai)
	local k = math_exp(ar)
	return k * math_cos(ai), k * math_sin(ai)
end

function Cat.UnpackedComplex.Log(ar, ai)
	return math_log(Cat.UnpackedComplex.Abs(ar, ai)), Cat.UnpackedComplex.Arg(ar, ai)
end

-- Utility
function Cat.UnpackedComplex.Clone(ar, ai)
	return ar, ai
end

function Cat.UnpackedComplex.Equals(ar, ai, br, bi)
	return ar == br and ai == bi
end

function Cat.UnpackedComplex.ToString(ar, ai)
	return tostring(ar) .. " + " .. tostring(ai) .. "i"
end
