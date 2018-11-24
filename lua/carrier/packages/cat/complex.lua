local self = {}
Cat.Complex = Class(self)

local tostring   = tostring

local math_atan2 = math.atan2
local math_cos   = math.cos
local math_exp   = math.exp
local math_log   = math.log
local math_sin   = math.sin
local math_sqrt  = math.sqrt

function Cat.Complex.Zero(out)
	local out = out or Cat.Complex()
	out[0], out[1] = 0, 0
	return out
end

function Cat.Complex.One(out)
	local out = out or Cat.Complex()
	out[0], out[1] = 1, 0
	return out
end

function self:ctor(x, y)
	self[0], self[1] = x, y
end

-- Arithmetic
function Cat.Complex.Add(a, b, out)
	local out = out or Cat.Complex()
	out[0], out[1] = a[0] + b[0], a[1] + b[1]
	return out
end

function Cat.Complex.Subtract(a, b, out)
	local out = out or Cat.Complex()
	out[0], out[1] = a[0] - b[0], a[1] - b[1]
	return out
end

function Cat.Complex.Multiply(a, b, out)
	local out = out or Cat.Complex()
	out[0], out[1] = a[0] * b[0] - a[1] * b[1], a[0] * b[1] + a[1] * b[0]
	return out
end

function Cat.Complex.Divide(a, b, out)
	-- ar + i ai   (ar + i ai)(br - i bi)
	-- --------- = ----------------------
	-- br + i bi   (br + i bi)(br - i bi)
	--
	--             ar br + ai bi + i(ai br - ar bi)
	--           = --------------------------------
	--                     br br + bi bi
	local out = out or Cat.Complex()
	local k = 1 / (b[0] * b[0] + b[1] * b[1])
	out[0], out[1] = k * (a[0] * b[0] + a[1] * b[1]), k * (a[1] * b[0] - a[0] * b[1])
	return out
end

function Cat.Complex.Negate(a, out)
	local out = out or Cat.Complex()
	out[0], out[1] = -a[0], -a[1]
	return out
end

function Cat.Complex.Scale(a, k, out)
	local out = out or Cat.Complex()
	out[0], out[1] = k * a[0], k * a[1]
	return out
end

function Cat.Complex.Exponentiate(a, b, out)
	local out = out or Cat.Complex()
	return Cat.Complex.Exp(Cat.Complex.Multiply(b, Cat.Complex.Log(a, out), out), out)
end

self.Add            = Cat.Complex.Add
self.Subtract       = Cat.Complex.Subtract
self.Multiply       = Cat.Complex.Multiply
self.Divide         = Cat.Complex.Divide
self.Negate         = Cat.Complex.Negate
self.Scale          = Cat.Complex.Scale
self.Exponentiate   = Cat.Complex.Exponentiate

-- Other
function Cat.Complex.Abs(a)
	return math_sqrt(a[0] * a[0] + a[1] * a[1])
end

function Cat.Complex.Arg(a)
	return math_atan2(a[1], a[0])
end

function Cat.Complex.Conjugate(a, out)
	local out = out or Cat.Complex()
	out[0], out[1] = self[0], -self[1]
	return out
end

function Cat.Complex.Exp(a, out)
	-- e^(ar + i ai) = e^ar e^(i ai)
	local out = out or Cat.Complex()
	local k = math_exp(a[0])
	out[0], out[1] = k * math_cos(a[1]), k * math_sin(a[1])
	return out
end

function Cat.Complex.Log(a, out)
	local out = out or Cat.Complex()
	out[0], out[1] = math_log(Cat.Complex.Abs(a)), Cat.Complex.Arg(a)
	return out
end

self.Abs            = Cat.Complex.Abs
self.Arg            = Cat.Complex.Arg
self.Conjugate      = Cat.Complex.Conjugate
self.Exp            = Cat.Complex.Exp
self.Log            = Cat.Complex.Log

-- Utility
function Cat.Complex.Clone(self, out)
	local out = out or Cat.Complex()
	out[0], out[1] = self[0], self[1]
	return out
end

function Cat.Complex.Equals(a, b)
	return a[0] == b[0] and a[1] == b[1]
end

function Cat.Complex.ToString(self)
	return tostring(self[0]) .. " + " .. tostring(self[1]) .. "i"
end

self.Clone    = Cat.Complex.Clone
self.Equals   = Cat.Complex.Equals
self.ToString = Cat.Complex.ToString
