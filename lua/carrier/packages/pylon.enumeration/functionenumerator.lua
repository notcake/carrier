local self = {}
Enumeration.FunctionEnumerator = Class(self, Enumeration.IEnumerator)

function self:Next()
	return self()
end
