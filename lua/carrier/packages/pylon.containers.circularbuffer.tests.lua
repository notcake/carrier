-- PACKAGE Pylon.Containers.CircularBuffer.Tests

local CircularBuffer = require("Pylon.Containers.CircularBuffer")

function Test(buffer, elements)
	local capacity = buffer:GetCapacity()
	
	for i = 1, #elements do
		buffer:Push(elements[i])
	end
	
	-- Forward get
	for i = 1, capacity do
		assert(buffer:Get(i) == elements[#elements - math.min(#elements, capacity) + i])
	end
	for i = capacity + 1, 2 * capacity do
		assert(buffer:Get(i) == nil)
	end
	
	-- Backward get
	for i = 1, capacity do
		assert(buffer:Get(-i) == elements[#elements - i + 1])
	end
	for i = capacity + 1, 2 * capacity do
		assert(buffer:Get(-i) == nil)
	end
	
	-- Forward enumerator
	local enumerator = buffer:GetEnumerator()
	for i = 1, capacity do
		assert(enumerator() == buffer:Get(i))
	end
	for i = 1, 2 * capacity do
		assert(enumerator() == nil)
	end
	
	assert(buffer:GetCount() == math.min(capacity, #elements))
end

return function()
	local buffer = CircularBuffer(10)
	Test(buffer, { 3, 4, 5 })
	buffer:Clear()
	Test(buffer, { 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70 })
	
	return true
end
