local self = {}
Analysis.DataFlowGraph.BinaryOperatorNode = Class (self, Analysis.DataFlowGraph.Node)

function self:ctor (address, leftDataFlowNode, rightDataFlowNode, operator)
	self.LeftDataFlowNode  = leftDataFlowNode
	self.RightDataFlowNode = rightDataFlowNode
	self.Operator = operator
end

-- Node
function self:EvaluateConstant (arguments, cachingEvaluator)
	local left  = cachingEvaluator (self.LeftDataFlowNode,  arguments)
	local right = cachingEvaluator (self.RightDataFlowNode, arguments)
	if left and right then
		return self.Operator:Evaluate (left, right)
	end
	return nil
end

function self:ToString ()
	return self.LeftDataFlowNode:ToString () .. " " .. self.Operator:GetSymbol () .. " " .. self.RightDataFlowNode:ToString ()
end

-- BinaryOperatorNode
function self:GetLeftDataFlowNode ()
	return self.LeftDataFlowNode
end

function self:GetRightDataFlowNode ()
	return self.RightDataFlowNode
end
