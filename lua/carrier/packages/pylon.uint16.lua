local UInt16 = {}

local bit_band   = bit.band
local bit_lshift = bit.lshift
local bit_rshift = bit.rshift

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

UInt16.add = UInt16.Add
UInt16.adc = UInt16.AddWithCarry
UInt16.sub = UInt16.Subtract
UInt16.sbb = UInt16.SubtractWithBorrow
UInt16.mul = UInt16.Multiply

return UInt16
