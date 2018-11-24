local self = Enumeration.IEnumerator:GetMethodTable()

local function ToFunction(f)
	if type(f) == "function" then return f end
	
	return function(x, ...)
		return x[f](x, ...)
	end
end

function self:Concat(separator)
	return table.concat(self:Map(tostring):ToArray(), separator)
end

function self:Foldl(seed, binaryFunction, ...)
	binaryFunction = ToFunction(binaryFunction)
	
	local x = self()
	while x ~= nil do
		seed = binaryFunction(seed, x, ...)
		x = self()
	end
	
	return seed
end

function self:Filter(filterFunction)
	filterFunction = ToFunction(filterFunction)
	
	return EnumeratorFunction:RegisterFunction(
		function()
			local a, b, c, d, e, f = nil
			repeat
				a, b, c, d, e, f = self()
				if a == nil then return nil end
			until filterFunction(a, b, c, d, e, f)
			
			return a, b, c, d, e, f
		end
	)
end

function self:ForEach(actionFunction)
	actionFunction = ToFunction(actionFunction)
	
	for a, b, c, d, e, f in self do
		actionFunction(a, b, c, d, e, f)
	end
end

function self:Map(mapFunction)
	mapFunction = ToFunction(mapFunction)
	
	return EnumeratorFunction:RegisterFunction(
		function()
			local a, b, c, d, e, f = self()
			if a == nil then return nil end
			
			return mapFunction(a, b, c, d, e, f)
		end
	)
end

function self:ToArray()
	local array = {}
	for x in self do
		array[#array + 1] = x
	end
	return array
end

function self:ToSet()
	local set = {}
	for x in self do
		set[x] = true
	end
	return set
end

function self:Unpack()
	local value = self()
	if not value then return end
	return value, self:Unpack()
end
