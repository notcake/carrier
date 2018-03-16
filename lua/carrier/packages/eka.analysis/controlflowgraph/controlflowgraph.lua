local self = {}
Analysis.ControlFlowGraph = Class (self)

function self:ctor (link)
	self.Link = link or Analysis.ControlFlowGraph.Link
	
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

function self:AddLink (sourceSequence, destinationSequence)
	self.SequencePredecessors [destinationSequence] = self.SequencePredecessors [destinationSequence] or {}
	self.SequenceSuccessors   [sourceSequence]      = self.SequenceSuccessors   [sourceSequence]      or {}
	
	if self.SequenceSuccessors [sourceSequence] [destinationSequence] then
		return self.SequenceSuccessors [sourceSequence] [destinationSequence]
	else
		local link = self.Link (sourceSequence, destinationSequence)
		
		if self.SequenceLocks [destinationSequence] then
			self.SequencePredecessors [destinationSequence] = Map.Copy (self.SequencePredecessors [destinationSequence])
		end
		if self.SequenceLocks [sourceSequence] then
			self.SequenceSuccessors [sourceSequence] = Map.Copy (self.SequenceSuccessors [sourceSequence])
		end

		self.SequencePredecessors [destinationSequence] [sourceSequence]      = link
		self.SequenceSuccessors   [sourceSequence]      [destinationSequence] = link
		
		return link
	end
end

function self:GetLink (sourceSequence, destinationSequence)
	if not self.SequenceSuccessors [sourceSequence] then return nil end
	return self.SequenceSuccessors [sourceSequence] [destinationSequence]
end

function self:RemoveLink (sourceSequence, destinationSequence)
	if not destinationSequence then
		local link = sourceSequence
		sourceSequence, destinationSequence = link:GetSourceSequence (), link:GetDestinationSequence ()
	end
	
	if not self.SequenceSuccessors [sourceSequence] then return end
	
	self.SequencePredecessors [destinationSequence] [sourceSequence]      = nil
	self.SequenceSuccessors   [sourceSequence]      [destinationSequence] = nil
end
