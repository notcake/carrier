-- interface IEnumerator<T>
local self = {}
Enumeration.IEnumerator = Class (self)

function self:ctor ()
end

-- :() -> T
function self:__call ()
	return self:Next ()
end

-- :() -> T
function self:Next ()
	Error ("IEnumerator:Next : Not implemented.")
end
