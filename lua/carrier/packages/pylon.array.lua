-- PACKAGE Pylon.Array

Array = {}

function Array.Concat(array, separator)
	return table.concat(array, separator)
end
Array.concat = Array.Concat

function Array.Copy(array)
	local out = {}
	for i = 1, #array do
		out[i] = array[i]
	end
	return out
end
Array.copy  = Array.Copy
Array.clone = Array.copy
Array.Clone = Array.Copy

function Array.Filter(array, f)
	local out = {}
	for i = 1, #array do
		if f(array[i]) then
			out[#out + 1] = array[i]
		end
	end
	return out
end
Array.filter = Array.Filter

function Array.FlatMap(array, f)
	local out = {}
	for i = 1, #array do
		local results = f(array[i])
		for j = 1, #results do
			out[#out + 1] = results[j]
		end
	end
	return out
end
Array.flatMap = Array.FlatMap

function Array.ForEach(array, f)
	for i = 1, #array do
		f(array[i])
	end
end
Array.forEach = Array.ForEach

function Array.Map(array, f)
	local out = {}
	for i = 1, #array do
		out[i] = f(array[i])
	end
	return out
end
Array.map = Array.Map

function Array.Reverse(array, out)
	local out = out or {}
	for i = 1, math.ceil(#array * 0.5) do
		out[i], out[#array - i + 1] = array[#array - i + 1], array[i]
	end
	
	return out
end

function Array.ToSet(array, set)
	local set = set or {}
	for i = 1, #array do
		set[array[i]] = true
	end
	return set
end
Array.toSet = Array.ToSet

return Array
