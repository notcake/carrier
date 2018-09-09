-- PACKAGE Pylon.Set

Set = {}

function Set.Copy (set, out)
	local out = out or {}
	for k, _ in pairs (set) do
		out [k] = set [k]
	end
	return out
end
Set.copy  = Set.Copy
Set.clone = Set.copy
Set.Clone = Set.Copy

function Set.Intersect (a, b, out)
	local out = out or {}
	for k, _ in pairs (a) do
		if b [k] then
			out [k] = true
		end
	end
	
	return out
end
Set.intersect = Set.Intersect

function Set.Intersects (a, b)
	for k, _ in pairs (a) do
		if b [k] then return true
	end
	
	return false
end
Set.intersects = Set.Intersects

function Set.IntersectArray (array, out)
	local out = out or {}
	
	if #array == 0 then return out end
	
	local out = Set.Copy (array [1], out)
	
	for i = 2, #array do
		for k, _ in pairs (out) do
			if not array [i] [k] then
				out [k] = nil
			end
		end
	end
	
	return out
end

function Set.Union (a, b, out)
	local out = out or {}
	for k, _ in pairs (a) do
		out [k] = true
	end
	for k, _ in pairs (b) do
		out [k] = true
	end
	
	return out
end
Set.union = Set.Union

function Set.UnionArray (array, out)
	local out = out or {}
	
	for i = 1, #array do
		for k, _ in pairs (array [i]) do
			out [k] = true
		end
	end
	
	return out
end

function Set.Filter (set, f, out)
	local out = out or {}
	for item, _ in pairs (set) do
		if f (item) then
			out [item] = true
		end
	end
	return out
end
Set.filter = Set.Filter

function Set.FlatMap (set, f, out)
	local out = out or {}
	for item, _ in pairs (set) do
		for item, _ in pairs (f (item)) do
			out [item] = true
		end
	end
	return set
end
Set.flatMap = Set.FlatMap

function Set.ForEach (set, f)
	for item, _ in pairs (set) do
		f (item)
	end
end
Set.forEach = Set.ForEach

function Set.Map (set, f, out)
	local out = out or {}
	for item, _ in pairs (set) do
		out [f (item)] = true
	end
	return t
end
Set.map = Set.Map

function Set.ToArray (set, array)
	local array = array or {}
	for item, _ in pairs (set) do
		array [#array + 1] = item
	end
	return array
end
Set.toArray = Set.ToArray

return Set
