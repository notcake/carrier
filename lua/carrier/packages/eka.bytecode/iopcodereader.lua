local self = {}
Bytecode.IOpcodeReader = Class(self, IDisposable)

function self:ctor()
end

function self:GetOpcodeInfo()
	Error("IOpcodeReader:GetOpcodeInfo : Not implemented.")
end

function self:GetPosition()
	Error("IOpcodeReader:GetPosition : Not implemented.")
end

function self:IsEndOfStream()
	Error("IOpcodeReader:IsEndOfStream : Not implemented.")
end

function self:SeekAbsolute(seekPos)
	Error("IOpcodeReader:SeekAbsolute : Not implemented.")
end

function self:SeekRelative(relativeSeekPos)
	self:SeekAbsolute(self:GetPosition() + relativeSeekPos)
end

-- :() -> uint64 opcode, ...
function self:Decode()
	Error("IOpcodeReader:Decode : Not implemented.")
end
