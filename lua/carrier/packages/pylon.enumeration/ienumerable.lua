-- interface IEnumerable<T>
local self = {}
Enumeration.IEnumerable = Interface (self)

function self:ctor ()
end

-- :() -> IEnumerator<T>
function self:GetEnumerator ()
	Error ("IEnumerable:GetEnumerator : Not implemented.")
end
