-- PACKAGE Pylon.Set

Set = {}

function Set.ToArray (set)
	local set = {}
	for item, _ in pairs (set) do
		set [#set + 1] = item
	end
	return set
end
Set.toArray = Set.ToArray

function Set.Filter (set, f)
	local out = {}
	for item, _ in pairs (set) do
		if f (item) then
			out [item] = true
		end
	end
	return out
end
Set.filter = Set.Filter

function Set.FlatMap (set, f)
	local out = {}
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

function Set.Map (set, f)
	local out = {}
	for item, _ in pairs (set) do
		out [f (item)] = true
	end
	return t
end
Set.map = Set.Map

return Set
