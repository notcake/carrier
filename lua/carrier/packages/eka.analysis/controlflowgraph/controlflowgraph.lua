local self = {}
Analysis.ControlFlowGraph = Class (self)

function self:ctor ()
	self.SequencesByStartAddress = {}
end

function self:AddSequence (sequence)
	self.SequencesByStartAddress [sequence:GetStartAddress ()] = sequence
end

function self:GetSequence (startAddress)
	return self.SequencesByStartAddress [startAddress]
end

function self:IsSequenceStart (startAddress)
	return self:GetSequence (startAddress) ~= nil
end
