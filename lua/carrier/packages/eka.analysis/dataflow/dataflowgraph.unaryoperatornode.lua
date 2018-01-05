local self = {}
Analysis.DataFlowGraph.UnaryOperatorNode = Class (self, Analysis.DataFlowGraph.Node)

function self:ctor (address, operator, innerDataFlowNode)
	self.Operator = operator
	
	self.InnerDataFlowNode = innerDataFlowNode
end

-- Node
function self:EvaluateConstant (arguments, cachingEvaluator)
	local inner = cachingEvaluator (self.InnerDataFlowNode, arguments)
	if inner then
		return self.Operator:Evaluate (inner)
	end
	return nil
end

function self:GetOperator ()
	return self.Operator
end

function self:ToString ()
	local innerExpression = self.InnerDataFlowNode:ToString ()
	if self.InnerDataFlowNode:GetOperator () and
	   self.InnerDataFlowNode:GetOperator ():GetPrecedence () >= self.Operator:GetPrecedence () and
	   self.InnerDataFlowNode:GetOperator ():GetAssociativity () ~= self.Operator:GetAssociativity () then
		innerExpression = "(" .. innerExpression .. ")"
	end
	
	if self.Operator:GetAssociativity () == AST.Associativity.Left then
		return innerExpression .. self.Operator:GetSymbol ()
	elseif self.Operator:GetAssociativity () == AST.Associativity.Right then
		return self.Operator:GetSymbol () .. innerExpression
	end
end

-- UnaryOperatorNode
function self:GetInnerDataFlowNode ()
	return self.InnerDataFlowNode
end
