local self = {}
Analysis.DataFlowGraph.Node = Class (self)

function self:ctor (address)
	self.Address = address
end

function self:GetAddress ()
	return self.Address
end

function self:GetDependencies (out)
	return out or {}
end

-- Expression
function self:EvaluateConstant (inputSubstitutionMap, cachingEvaluator)
	return nil
end

function self:GetOperator ()
	return nil
end

-- IO
function self:IsInputNode ()
	return false
end

function self:IsOutputNode ()
	return false
end

function self:GetAliasingGroup ()
	return nil
end

-- Phi
function self:IsPhiNode ()
	return false
end

function self:ToString ()
	return "{ DataFlowGraph.Node }"
end
