local self = {}
Analysis.SET.While = Class (self, Analysis.SET.Node)

function self:ctor (conditionBlock)
	self.ConditionBlock = conditionBlock
	
	self.Blocks = {}
	
	self:AddBlock (self.ConditionBlock)
end

-- Node
function self:ContainsBlock (block)
	return self.Blocks [block] or false
end

function self:GetBlockEnumerator ()
	return KeyEnumerator (self.Blocks)
end

-- While
function self:SetConditionBlock (conditionBlock)
	self.ConditionBlock = conditionBlock
	self:AddBlock (self.ConditionBlock)
end

function self:AddBlock (block)
	self.Blocks [block] = true
end
