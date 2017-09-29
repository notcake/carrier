local self = {}
Bytecode.IOpcodeInfo = Class (self)

function self:ctor ()
end

function self:GetByName (name)
	Error ("IOpcodeInfo:GetByName : Not implemented")
end

function self:GetName (opcode)
	Error ("IOpcodeInfo:GetName : Not implemented")
end

function self:GetMinimumLength ()
	Error ("IOpcodeInfo:GetMinimumLength : Not implemented")
end

function self:GetMinimumLength ()
	Error ("IOpcodeInfo:GetMinimumLength : Not implemented")
end

function self:GetMinimumOperandCount ()
	Error ("IOpcodeInfo:GetMinimumOperandCount : Not implemented")
end

function self:GetMaximumOperandCount ()
	Error ("IOpcodeInfo:GetMaximumOperandCount : Not implemented")
end

function self:GetOperandCount (opcode)
	Error ("IOpcodeInfo:GetOperandCount : Not implemented")
end

function self:GetBranchType (opcode)
	Error ("IOpcodeInfo:GetBranchType : Not implemented")
end

function self:IsBranch (opcode)
	return self:GetBranchType (opcode) ~= Bytecode.BranchType.None
end

-- :(uint8[], uint64) -> uint64 length, uint64 opcode, ...
function self:Decode (data, offset)
	Error ("IOpcodeInfo:Decode : Not implemented")
end

-- :(IInputStream) -> uint64 opcode, ...
function self:DecodeFromStream (inputStream)
	Error ("IOpcodeInfo:DecodeFromStream : Not implemented")
end

-- :(uint64 opcode, ...) -> uint8[]
function self:Encode (opcode, ...)
	Error ("IOpcodeInfo:Encode : Not implemented")
end

-- :(IOutputStream, uint64 opcode, ...) -> ()
function self:EncodeToStream (inputStream)
	Error ("IOpcodeInfo:EncodeToStream : Not implemented")
end

-- :(uint64 opcode, ...) -> string
function self:Format (opcode, ...)
	Error ("IOpcodeInfo:Format : Not implemented")
end
