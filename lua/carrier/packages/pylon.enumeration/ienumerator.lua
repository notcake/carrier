local self = {}
Enumeration.IEnumerator = Class (self)

function self:ctor ()
end

function self:__call ()
	return self:Next ()
end

function self:Next ()
	Error ("IEnumerator:Next : Not implemented.")
end
