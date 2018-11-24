-- PACKAGE Pylon.Table

local Table = {}

function Table.Callable(f)
	return setmetatable({},
		{
			__call = function(_, ...)
				return f(...)
			end
		}
	)
end

return Table
