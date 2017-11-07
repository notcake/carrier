-- PACKAGE Pylon.Functional

local Functional = {}

function Functional.Curry (f, x)
	return function (...)
		return f (x, ...)
	end
end

Functional.curry = Functional.Curry

return Functional
