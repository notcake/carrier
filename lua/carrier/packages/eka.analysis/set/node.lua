local self = {}
Analysis.SET.Node = Class(self)

function self:ctor()
end

-- Node
function self:ContainsBlock(block)
	return false
end

function self:GetBlockEnumerator()
	return NullEnumerator()
end
