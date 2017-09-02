local UInt32 = {}

local bit_band   = bit.band
local bit_lshift = bit.lshift
local bit_rshift = bit.rshift
local math_floor = math.floor

-- Note: Branchless implementations of these operations with mods and divs
--       are faster than branching ones, except when the branch predictor
--       is always right.

-- ~14 ns
function UInt32.Add (a, b)
	local c = a + b
	return c % 4294967296, math_floor (c / 4294967296)
end

-- ~15 ns
function UInt32.AddWithCarry (a, b, cf)
	local c = a + b + cf
	return c % 4294967296, math_floor (c / 4294967296)
end

-- ~14 ns
function UInt32.Subtract (a, b)
	local c = a - b
	return c % 4294967296, -math_floor (c / 4294967296)
end

-- ~15 ns
function UInt32.SubtractWithBorrow (a, b, cf)
	local c = a - b - cf
	return c % 4294967296, -math_floor (c / 4294967296)
end

-- ~25 ns
function UInt32.Multiply (a, b)
	local a0, a1 = bit_band (a, 0xFFFF), bit_rshift (a, 16)
	local c = a0 * b
	local low, high = c % 4294967296, math_floor (c / 4294967296)
	
	local c = a1 * b
	low  = low  + bit_lshift (c, 16)
	high = high + math_floor (c / 0x00010000)
	
	-- Carry
	high = high + math_floor (low / 4294967296)
	low  = low % 4294967296
	
	return low, high
end

UInt32.add = UInt32.Add
UInt32.adc = UInt32.AddWithCarry
UInt32.sub = UInt32.Subtract
UInt32.sbb = UInt32.SubtractWithBorrow
UInt32.mul = UInt32.Multiply

return UInt32
