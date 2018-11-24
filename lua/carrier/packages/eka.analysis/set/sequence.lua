local self = {}
Analysis.SET.Sequence = Class (self, Analysis.SET.Node)

function self:ctor ()
	self.Blocks = {}
end

-- Node
function self:ContainsBlock (block)
	return self.Blocks [block] or false
end

function self:GetBlockEnumerator ()
	return KeyEnumerator (self.Blocks)
end

-- Sequence
function self:AddBlock (block)
	self.Blocks [block] = true
end
