local bit = require ("bit")

local bit_band      = bit.band
local bit_bxor      = bit.bxor
local bit_rshift    = bit.rshift
local bit_tobit     = bit.tobit
local string_byte   = string.byte
local string_char   = string.char

local sbox =
{
	[0] = 12,  5,  6, 11,
	       9,  0, 10, 13,
	       3, 14, 15,  8,
	       4,  7,  1,  2
}

-- PHOTON-128 round constants
local roundConstants =
{
	{ [0] =  1,  0,  2,  6,  7,  5 },
	{ [0] =  3,  2,  0,  4,  5,  7 },
	{ [0] =  7,  6,  4,  0,  1,  3 },
	{ [0] = 14, 15, 13,  9,  8, 10 },
	{ [0] = 13, 12, 14, 10, 11,  9 },
	{ [0] = 11, 10,  8, 12, 13, 15 },
	{ [0] =  6,  7,  5,  1,  0,  2 },
	{ [0] = 12, 13, 15, 11, 10,  8 },
	{ [0] =  9,  8, 10, 14, 15, 13 },
	{ [0] =  2,  3,  1,  5,  4,  6 },
	{ [0] =  5,  4,  6,  2,  3,  1 },
	{ [0] = 10, 11,  9, 13, 12, 14 }
}

-- PHOTON-128 MixColumns matrix
local mixColumns =
{
	[0] =  1,  2,  8,  5,  8,  2,
	       2,  5,  1,  2,  6, 12,
	      12,  9, 15,  8,  8, 13,
	      13,  5, 11,  3, 10,  1,
	       1, 15, 13, 14, 11,  8,
	       8,  2,  3,  3,  2,  8
}

-- Multiply over GF(2^4)
local function Multiply (a, b)
	local a, b = bit_tobit (a), bit_tobit (b)
	local x = a
	local c = bit_tobit (0)
	for _ = 0, 3 do
		if bit_band (b, 1) ~= 0 then
			c = bit_bxor (c, x)
		end
		b = bit_rshift (b, 1)
		
		if bit_band (x, 0x8) ~= 0 then
			x = x * 2
			x = bit_bxor (x, 3)
		else
			x = x * 2
		end
	end
	
	return bit_band (c, 0x0F)
end

-- Compute S-box-MixColumns lookup table
-- (row, value) -> packed contributions for whole column
local sboxMixColumnsLookup = {}
for y = 0, 5 do
	sboxMixColumnsLookup [y] = {}
	local sboxMixColumnsLookup = sboxMixColumnsLookup [y]
	for c = 0, 15 do
		local out = bit_tobit (0)
		for y1 = 5, 0, -1 do
			out = out * 16
			out = out + Multiply (mixColumns [y1 * 6 + y], sbox [c])
		end
		sboxMixColumnsLookup [c] = out
	end
end

local function PrintState (state)
	local out = ""
	for y = 0, 5 do
		for x = 0, 5 do
			if x > 0 then out = out .. ", " end
			out = out .. string.format ("%01x", state [y * 6 + x])
		end
		out = out .. "\n"
	end
	Msg (out)
end

local function Permute (state1, state2)
	for round = 1, 12 do
		-- Add round key
		local roundConstants = roundConstants [round]
		for y = 0, 5 do
			state1 [y * 6 + 0] = bit_bxor (state1 [y * 6 + 0], roundConstants [y])
		end
		
		-- Shift rows
		state1 [1 * 6 + 0], state1 [1 * 6 + 1], state1 [1 * 6 + 2], state1 [1 * 6 + 3], state1 [1 * 6 + 4], state1 [1 * 6 + 5] = state1 [1 * 6 + 1], state1 [1 * 6 + 2], state1 [1 * 6 + 3], state1 [1 * 6 + 4], state1 [1 * 6 + 5], state1 [1 * 6 + 0]
		state1 [2 * 6 + 0], state1 [2 * 6 + 1], state1 [2 * 6 + 2], state1 [2 * 6 + 3], state1 [2 * 6 + 4], state1 [2 * 6 + 5] = state1 [2 * 6 + 2], state1 [2 * 6 + 3], state1 [2 * 6 + 4], state1 [2 * 6 + 5], state1 [2 * 6 + 0], state1 [2 * 6 + 1]
		state1 [3 * 6 + 0], state1 [3 * 6 + 1], state1 [3 * 6 + 2], state1 [3 * 6 + 3], state1 [3 * 6 + 4], state1 [3 * 6 + 5] = state1 [3 * 6 + 3], state1 [3 * 6 + 4], state1 [3 * 6 + 5], state1 [3 * 6 + 0], state1 [3 * 6 + 1], state1 [3 * 6 + 2]
		state1 [4 * 6 + 0], state1 [4 * 6 + 1], state1 [4 * 6 + 2], state1 [4 * 6 + 3], state1 [4 * 6 + 4], state1 [4 * 6 + 5] = state1 [4 * 6 + 4], state1 [4 * 6 + 5], state1 [4 * 6 + 0], state1 [4 * 6 + 1], state1 [4 * 6 + 2], state1 [4 * 6 + 3]
		state1 [5 * 6 + 0], state1 [5 * 6 + 1], state1 [5 * 6 + 2], state1 [5 * 6 + 3], state1 [5 * 6 + 4], state1 [5 * 6 + 5] = state1 [5 * 6 + 5], state1 [5 * 6 + 0], state1 [5 * 6 + 1], state1 [5 * 6 + 2], state1 [5 * 6 + 3], state1 [5 * 6 + 4]
		
		-- Substitute and MixColumns
		for x = 0, 5 do
			local column = bit_tobit (0)
			for y = 0, 5 do
				column = bit_bxor (column, sboxMixColumnsLookup [y] [state1 [y * 6 + x]])
			end
			for y = 0, 5 do
				state2 [y * 6 + x] = bit_band (column, 0x0F)
				column = bit_rshift (column, 4)
			end
		end
		
		state1, state2 = state2, state1
	end
	
	return state1, state2
end

-- PHOTON-128/32/32
function Crypto.PHOTON128 (input)
	local state1 =
	{
		[0] =  0,  0,  0,  0,  0,  0,
		       0,  0,  0,  0,  0,  0,
		       0,  0,  0,  0,  0,  0,
		       0,  0,  0,  0,  0,  0,
		       0,  0,  0,  0,  0,  0,
		       2,  0,  1,  0,  1,  0  -- 0x20, 0x10, 0x10
	}
	local state2 = {}
	
	-- Eat pairs of input bytes
	for i = 2, #input, 2 do
		local uint80, uint81 = string_byte (input, i - 1, i)
		uint80, uint81 = bit_tobit (uint80), bit_tobit (uint81)
		state1 [0] = bit_bxor (state1 [0], bit_rshift (uint80, 4))
		state1 [1] = bit_bxor (state1 [1], bit_band (uint80, 0x0F))
		state1 [2] = bit_bxor (state1 [2], bit_rshift (uint81, 4))
		state1 [3] = bit_bxor (state1 [3], bit_band (uint81, 0x0F))
		state1, state2 = Permute (state1, state2)
	end
	
	-- Either [last byte, 0x80] or [0x80, 0x00]
	if #input % 2 == 1 then
		local uint80 = bit_tobit (string_byte (input, #input))
		local uint40, uint41 = bit_rshift (uint80, 4), bit_band (uint80, 0x0F)
		state1 [0] = bit_bxor (state1 [0], bit_rshift (uint80, 4))
		state1 [1] = bit_bxor (state1 [1], bit_band (uint80, 0x0F))
		state1 [2] = bit_bxor (state1 [2], 0x08)
		state1 [3] = bit_bxor (state1 [3], 0x00)
	else
		state1 [0] = bit_bxor (state1 [0], 0x08)
		state1 [1] = bit_bxor (state1 [1], 0x00)
		state1 [2] = bit_bxor (state1 [2], 0x00)
		state1 [3] = bit_bxor (state1 [3], 0x00)
	end
	state1, state2 = Permute (state1, state2)
	
	-- Squeeze
	local uint80, uint81 = state1 [0] * 0x10 + state1 [1], state1 [2] * 0x10 + state1 [3]
	state1, state2 = Permute (state1, state2)
	local uint82, uint83 = state1 [0] * 0x10 + state1 [1], state1 [2] * 0x10 + state1 [3]
	state1, state2 = Permute (state1, state2)
	local uint84, uint85 = state1 [0] * 0x10 + state1 [1], state1 [2] * 0x10 + state1 [3]
	state1, state2 = Permute (state1, state2)
	local uint86, uint87 = state1 [0] * 0x10 + state1 [1], state1 [2] * 0x10 + state1 [3]
	state1, state2 = Permute (state1, state2)
	local uint88, uint89 = state1 [0] * 0x10 + state1 [1], state1 [2] * 0x10 + state1 [3]
	state1, state2 = Permute (state1, state2)
	local uint8a, uint8b = state1 [0] * 0x10 + state1 [1], state1 [2] * 0x10 + state1 [3]
	state1, state2 = Permute (state1, state2)
	local uint8c, uint8d = state1 [0] * 0x10 + state1 [1], state1 [2] * 0x10 + state1 [3]
	state1, state2 = Permute (state1, state2)
	local uint8e, uint8f = state1 [0] * 0x10 + state1 [1], state1 [2] * 0x10 + state1 [3]
	return string_char (uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87, uint88, uint89, uint8a, uint8b, uint8c, uint8d, uint8e, uint8f)
end
