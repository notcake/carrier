-- interface IEnumerable<T>
local self = {}
Enumeration.IEnumerable = Class (self)

function self:ctor ()
end

-- :() -> IEnumerator<T>
function self:GetEnumerator ()
	Error ("IEnumerable:GetEnumerator : Not implemented.")
end
