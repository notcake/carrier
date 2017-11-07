-- PACKAGE Pylon.UInt16

local UInt16 = {}

local bit_band   = bit.band
local bit_rshift = bit.rshift
local math_floor = math.floor
local math_log   = math.log
local math_max   = math.max

UInt16.Zero               = 0x0000
UInt16.Minimum            = 0x0000
UInt16.Maximum            = 0xFFFF
UInt16.MostSignificantBit = 0x8000
UInt16.BitCount           = 16

-- ~11 ns
function UInt16.Add (a, b)
	local c = a + b
	return bit_band (c, 0xFFFF), bit_rshift (c, 16)
end

-- ~13 ns
function UInt16.AddWithCarry (a, b, cf)
	local c = a + b + cf
	return bit_band (c, 0xFFFF), bit_rshift (c, 16)
end

-- ~11 ns
function UInt16.Subtract (a, b)
	local c = a - b
	return bit_band (c, 0xFFFF), bit_band (bit_rshift (c, 16), 1)
end

-- ~13 ns
function UInt16.SubtractWithBorrow (a, b, cf)
	local c = a - b - cf
	return bit_band (c, 0xFFFF), bit_band (bit_rshift (c, 16), 1)
end

-- ~12 ns
function UInt16.Multiply (a, b)
	local c = a * b
	return bit_band (c, 0xFFFF), bit_rshift (c, 16)
end

function UInt16.MultiplyAdd1 (a, b, c)
	local c = a * b + c
	return bit_band (c, 0xFFFF), bit_rshift (c, 16)
end
UInt16.MultiplyAdd = UInt16.MultiplyAdd1

function UInt16.MultiplyAdd2 (a, b, c, d)
	local c = a * b + c + d
	return bit_band (c, 0xFFFF), bit_rshift (c, 16)
end

function UInt16.Divide (low, high, divisor)
	local a = low + 0x00010000 * high
	return math_floor (a / divisor), a % divisor
end

local k = math_log (2)
function UInt16.CountLeadingZeros (x)
	return 16 - math_max (0, math_floor (1 + math_log(x) / k))
end

UInt16.add = UInt16.Add
UInt16.adc = UInt16.AddWithCarry
UInt16.sub = UInt16.Subtract
UInt16.sbb = UInt16.SubtractWithBorrow
UInt16.mul = UInt16.Multiply
UInt16.div = UInt16.Divide
UInt16.clz = UInt16.CountLeadingZeros

return UInt16
