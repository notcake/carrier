-- PACKAGE Pylon.Set

Set = {}

function Set.Copy(set, out)
	local out = out or {}
	for k, _ in pairs(set) do
		out[k] = set[k]
	end
	return out
end
Set.copy  = Set.Copy
Set.clone = Set.copy
Set.Clone = Set.Copy

function Set.Intersect(a, b, out)
	local out = out or {}
	for k, _ in pairs(a) do
		if b[k] then
			out[k] = true
		end
	end
	
	return out
end
Set.intersect = Set.Intersect

function Set.Intersects(a, b)
	for k, _ in pairs(a) do
		if b[k] then return true end
	end
	
	return false
end
Set.intersects = Set.Intersects

function Set.IntersectArray(array, out)
	local out = out or {}
	
	if #array == 0 then return out end
	
	local out = Set.Copy(array[1], out)
	
	for i = 2, #array do
		for k, _ in pairs(out) do
			if not array[i] [k] then
				out[k] = nil
			end
		end
	end
	
	return out
end

function Set.Union(a, b, out)
	local out = out or {}
	for k, _ in pairs(a) do
		out[k] = true
	end
	for k, _ in pairs(b) do
		out[k] = true
	end
	
	return out
end
Set.union = Set.Union

function Set.UnionArray(array, out)
	local out = out or {}
	
	for i = 1, #array do
		for k, _ in pairs(array[i]) do
			out[k] = true
		end
	end
	
	return out
end

function Set.Subtract(a, b, out)
	local out = Set.Copy(a, out)
	
	for k, _ in pairs(b) do
		out[k] = nil
	end
	
	return out
end
Set.subtract = Set.Subtract

function Set.Filter(set, f, out)
	local out = out or {}
	for k, _ in pairs(set) do
		if f(k) then
			out[k] = true
		end
	end
	return out
end
Set.filter = Set.Filter

function Set.FlatMap(set, f, out)
	local out = out or {}
	for k, _ in pairs(set) do
		for k, _ in pairs(f(k)) do
			out[k] = true
		end
	end
	return set
end
Set.flatMap = Set.FlatMap

function Set.ForEach(set, f)
	for k, _ in pairs(set) do
		f(k)
	end
end
Set.forEach = Set.ForEach

function Set.Map(set, f, out)
	local out = out or {}
	for k, _ in pairs(set) do
		out[f(k)] = true
	end
	return t
end
Set.map = Set.Map

function Set.ToArray(set, array)
	local array = array or {}
	for k, _ in pairs(set) do
		array[#array + 1] = k
	end
	return array
end
Set.toArray = Set.ToArray

return Set
