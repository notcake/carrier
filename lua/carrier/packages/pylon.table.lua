local Table = {}

function Table.Callable (f)
	return setmetatable ({},
		{
			__call = function (_, ...)
				return f (...)
			end
		}
	)
end

function Table.ShallowCopy (tbl, out)
	local out = out or {}
	
	for k, v in pairs (tbl) do
		out [k] = v
	end
	
	return out
end

function Table.Invert (tbl, out)
	local out = out or {}
	
	local keys = {}
	for key, _ in pairs (tbl) do
		keys [#keys + 1] = key
	end
	for i = 1, #keys do
		out [tbl [keys [i]]] = keys [i]
	end
	
	return out
end

function Table.GetKeys (tbl, out)
	local out = out or {}
	
	for key, _ in pairs (tbl) do
		out [#out + 1] = key
	end
	
	return out
end

function Table.GetValues (tbl, out)
	local out = out or {}
	
	for _, value in pairs (tbl) do
		out [#out + 1] = value
	end
	
	return out
end

return Table
