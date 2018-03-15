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

function self:Clone (cachingCloner)
	local clone = self:GetType () ()
	for k, v in pairs (self) do
		if Analysis.DataFlowGraph.Node:IsInstance (v) then
			clone [k] = cachingCloner (v)
		else
			clone [k] = v
		end
	end
	
	return clone
end

-- Expression
function self:EvaluateConstant (cachingEvaluator)
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
