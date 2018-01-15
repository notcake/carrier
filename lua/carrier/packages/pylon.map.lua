-- PACKAGE Pylon.Map

local Map = {}

function Map.Copy (map, out)
	local out = out or {}
	
	for k, v in pairs (map) do
		out [k] = v
	end
	
	return out
end
Map.copy  = Map.Copy
Map.clone = Map.copy
Map.Clone = Map.Copy

function Map.Invert (map, out)
	local out = out or {}
	
	local keys = Map.Keys (map)
	for i = 1, #keys do
		out [map [keys [i]]] = keys [i]
	end
	
	return out
end
Map.invert = Map.Invert

function Map.Keys (map, out)
	local out = out or {}
	
	for k, _ in pairs (map) do
		out [#out + 1] = k
	end
	
	return out
end
Map.keys = Map.Keys

function Map.Values (map, out)
	local out = out or {}
	
	for _, v in pairs (map) do
		out [#out + 1] = v
	end
	
	return out
end
Map.values = Map.Values

return Map
