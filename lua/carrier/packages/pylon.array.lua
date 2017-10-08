Array = {}

function Array.Concat (t, separator)
	return table.concat (t, separator)
end
Array.concat = Array.Concat

function Array.Copy (t)
	local out = {}
	for i = 1, #t do
		out [i] = t [i]
	end
	return out
end
Array.copy = Array.Copy

function Array.Filter (t, f)
	local out = {}
	for i = 1, #t do
		if f (t [i]) then
			out [#out + 1] = t [i]
		end
	end
	return out
end
Array.filter = Array.Filter

function Array.FlatMap (t, f)
	local out = {}
	for i = 1, #t do
		local results = f (t [i])
		for j = 1, #results do
			out [#out + 1] = results [j]
		end
	end
	return out
end
Array.flatMap = Array.FlatMap

function Array.ForEach (t, f)
	for i = 1, #t do
		f (t [i])
	end
end
Array.forEach = Array.ForEach

function Array.Map (t, f)
	local out = {}
	for i = 1, #t do
		out [i] = f (t [i])
	end
	return out
end
Array.map = Array.Map

return Array
