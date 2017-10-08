local UInt24 = {}

local bit_band   = bit.band
local math_floor = math.floor
local math_log   = math.log
local math_max   = math.max

UInt24.Zero               = 0x00000000
UInt24.Minimum            = 0x00000000
UInt24.Maximum            = 0x00FFFFFF
UInt24.MostSignificantBit = 0x00800000
UInt24.BitCount           = 24

-- ~11 ns
function UInt24.Add (a, b)
	local c = a + b
	return bit_band (c, 0x00FFFFFF), math_floor (c / 0x01000000)
end

-- ~12 ns
function UInt24.AddWithCarry (a, b, cf)
	local c = a + b + cf
	return bit_band (c, 0x00FFFFFF), math_floor (c / 0x01000000)
end

-- ~11 ns
function UInt24.Subtract (a, b)
	local c = a - b
	return bit_band (c, 0x00FFFFFF), -math_floor (c / 0x01000000)
end

-- ~13 ns
function UInt24.SubtractWithBorrow (a, b, cf)
	local c = a - b - cf
	return bit_band (c, 0x00FFFFFF), -math_floor (c / 0x01000000)
end

-- ~12 ns
function UInt24.Multiply (a, b)
	local c = a * b
	return bit_band (c, 0x00FFFFFF), math_floor (c / 0x01000000)
end

function UInt24.MultiplyAdd1 (a, b, c)
	local c = a * b + c
	return bit_band (c, 0x00FFFFFF), math_floor (c / 0x01000000)
end
UInt24.MultiplyAdd = UInt24.MultiplyAdd1

function UInt24.MultiplyAdd2 (a, b, c, d)
	local c = a * b + c + d
	return bit_band (c, 0x00FFFFFF), math_floor (c / 0x01000000)
end

function UInt24.Divide (low, high, divisor)
	local a = low + 0x01000000 * high
	return math_floor (a / divisor), a % divisor
end

local k = math_log (2)
function UInt24.CountLeadingZeros (x)
	return 24 - math_max (0, math_floor (1 + math_log(x) / k))
end

UInt24.add = UInt24.Add
UInt24.adc = UInt24.AddWithCarry
UInt24.sub = UInt24.Subtract
UInt24.sbb = UInt24.SubtractWithBorrow
UInt24.mul = UInt24.Multiply
UInt24.div = UInt24.Divide
UInt24.clz = UInt24.CountLeadingZeros

return UInt24
