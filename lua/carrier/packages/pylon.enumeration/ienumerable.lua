local self = {}
Enumeration.IEnumerable = Class (self)

function self:ctor ()
end

function self:GetEnumerator ()
	Error ("IEnumerable:GetEnumerator : Not implemented.")
end
