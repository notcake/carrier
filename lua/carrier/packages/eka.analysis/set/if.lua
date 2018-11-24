local self = {}
Analysis.SET.If = Class(self, Analysis.SET.Node)

function self:ctor(conditionBlock)
	-- The condition block is not actually part of the if block set
	-- since it contains statements outside of the if statement
	self.ConditionBlock = conditionBlock
	
	self.Blocks = {}
	self.BodyBlocks = {}
	self.ElseBlocks = {}
end

-- Node
function self:ContainsBlock(block)
	return self.Blocks[block] or false
end

function self:GetBlockEnumerator()
	return KeyEnumerator(self.Blocks)
end

-- If
function self:SetConditionBlock(conditionBlock)
	self.ConditionBlock = conditionBlock
end

function self:AddBodyBlock(block)
	self.Blocks[block] = true
	self.BodyBlocks[block] = true
end

function self:AddElseBlock(block)
	self.Blocks[block] = true
	self.ElseBlocks[block] = true
end
