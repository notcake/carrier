local UInt24 = {}

local bit_band   = bit.band
local math_floor = math.floor

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

UInt24.add = UInt24.Add
UInt24.adc = UInt24.AddWithCarry
UInt24.sub = UInt24.Subtract
UInt24.sbb = UInt24.SubtractWithBorrow
UInt24.mul = UInt24.Multiply

return UInt24
