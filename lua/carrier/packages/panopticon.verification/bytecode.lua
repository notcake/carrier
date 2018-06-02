-- Copyright !cake
-- This software is proprietary and may not be copied, distributed, modified,
-- incorporated into another software program, linked with another software program,
-- loaded by another software program or used to create derivative works
-- without the explicit permission of its author.

local bit_band          = bit.band
local jit_util_funcbc   = jit_util.funcbc
local jit_util_funcinfo = jit_util.funcinfo
local math_floor        = math.floor
local string_char       = string.char
local string_gsub       = string.gsub
local table_concat      = table.concat

local normalizeStripOpcodeMap =
{
	[0x46] = 0x51, -- RET    -> LOOP
	[0x47] = 0x51, -- RET0   -> LOOP
	[0x48] = 0x51, -- RET1   -> LOOP
	[0x49] = 0x49, -- FORI   -> FORI
	[0x4A] = 0x49, -- JFORI  -> FORI
	[0x4B] = 0x4B, -- FORL   -> FORL
	[0x4C] = 0x4B, -- IFORL  -> FORL
	[0x4D] = 0x4B, -- JFORL  -> FORL
	[0x4E] = 0x4E, -- ITERL  -> ITERL
	[0x4F] = 0x4E, -- IITERL -> ITERL
	[0x50] = 0x4E, -- JITERL -> ITERL
	[0x51] = 0x51, -- LOOP   -> LOOP
	[0x52] = 0x51, -- ILOOP  -> LOOP
	[0x53] = 0x51, -- JLOOP  -> LOOP
}

local normalizeOpcodeMap =
{
	[0x44] = 0x54, -- ISNEXT -> JMP
	[0x42] = 0x41, -- ITERN  -> ITERC
}

local normalizeStripOpcodeReplacementMap = {}
for opcode, replacement in pairs (normalizeStripOpcodeMap) do
	normalizeStripOpcodeReplacementMap [string_char (opcode)] = string_char (replacement, 0, 0, 0)
end
local normalizedOpcodeReplacementMap = {}
for opcode, replacement in pairs (normalizeOpcodeMap) do
	normalizedOpcodeReplacementMap [string_char (opcode)] = string_char (replacement)
end

function Verification.NormalizedBytecodeFromBytecodeDump (bytecode)
	return string_gsub (bytecode, "(.)(...)",
		function (instruction, operands)
			if normalizeStripOpcodeReplacementMap [instruction] then
				return normalizeStripOpcodeReplacementMap [instruction]
			end
			
			if normalizedOpcodeReplacementMap [instruction] then
				return normalizedOpcodeReplacementMap [instruction] .. operands
			end
		end
	)
end

function Verification.NormalizedBytecodeFromFunction (f, instructionCount)
	local t = {}
	
	-- Skip the function header pseudo-instruction
	instructionCount = instructionCount or jit_util_funcinfo (f).bytecodes
	instructionCount = instructionCount - 1
	
	for i = 1, instructionCount do
		local instruction = jit_util_funcbc (f, i)
		local opcode      = bit_band (instruction, 0xFF)
		
		if normalizeStripOpcodeMap [opcode] then
			-- Strip off operands
			instruction = normalizeStripOpcodeMap [opcode]
		end
		
		if normalizeOpcodeMap [opcode] then
			-- Remap opcode only
			instruction = instruction - opcode
			instruction = instruction + normalizeOpcodeMap [opcode]
		end
		
		t [#t + 1] = string_char (instruction % 256, math_floor (instruction * (1 / 256)) % 256, math_floor (instruction * (1 / 65536)) % 256, math_floor (instruction * (1 / 16777216)) % 256)
	end
	
	return table_concat (t)
end
