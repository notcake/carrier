local self = {}
Analysis.ControlFlowGraph = Class (self)

function self:ctor ()
	self.SequencesByStartAddress = {}
	
	self.SequenceLocks        = {}
	self.SequencePredecessors = {}
	self.SequenceSuccessors   = {}
end

function self:AddSequence (sequence)
	self.SequencesByStartAddress [sequence:GetStartAddress ()] = sequence
end

function self:GetSequence (startAddress)
	return self.SequencesByStartAddress [startAddress]
end

function self:GetSequencePredecessorEnumerator (sequence)
	if not self.SequencePredecessors [sequence] then return NullEnumerator () end
	return KeyValueEnumerator (self.SequencePredecessors [sequence])
end

function self:GetSequenceSuccessorEnumerator (sequence)
	if not self.SequenceSuccessors [sequence] then return NullEnumerator () end
	return KeyValueEnumerator (self.SequenceSuccessors [sequence])
end

function self:IsSequenceStart (startAddress)
	return self:GetSequence (startAddress) ~= nil
end

function self:LockSequenceLinks (sequence)
	self.SequenceLocks [sequence] = self.SequenceLocks [sequence] or 0
	self.SequenceLocks [sequence] = self.SequenceLocks [sequence] + 1
end

function self:UnlockSequenceLinks (sequence)
	self.SequenceLocks [sequence] = self.SequenceLocks [sequence] - 1
	if not self.SequenceLocks [sequence] then
		self.SequenceLocks [sequence] = nil
	end
end

function self:AddLink (link)
	local sourceSequence, destinationSequence = link:GetSourceSequence (), link:GetDestinationSequence ()
	self.SequencePredecessors [destinationSequence] = self.SequencePredecessors [destinationSequence] or {}
	self.SequenceSuccessors   [sourceSequence]      = self.SequenceSuccessors   [sourceSequence]      or {}
	
	if self.SequenceLocks [destinationSequence] then
		self.SequencePredecessors [destinationSequence] = Table.ShallowCopy (self.SequencePredecessors [destinationSequence])
	end
	if self.SequenceLocks [sourceSequence] then
		self.SequenceSuccessors [sourceSequence] = Table.ShallowCopy (self.SequenceSuccessors [sourceSequence])
	end
	
	self.SequencePredecessors [destinationSequence] [sourceSequence]      = link
	self.SequenceSuccessors   [sourceSequence]      [destinationSequence] = link
end
