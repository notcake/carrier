-- PACKAGE Pylon.Containers.CircularBuffer

local OOP = require("Pylon.OOP")
local ICollection = require("Pylon.Containers.ICollection")

local self = {}
local CircularBuffer = OOP.Class(self, ICollection)

function self:ctor(capacity)
	self.Capacity   = capacity
	self.Count      = 0
	self.ReadIndex  = 1
	self.WriteIndex = 1
end

function self:Clear()
	if self.Count == 0 then return end
	
	if self.ReadIndex < self.WriteIndex then
		for i = self.ReadIndex, self.WriteIndex - 1 do
			self[i] = nil
		end
	else
		for i = 1, self.WriteIndex - 1 do
			self[i] = nil
		end
		for i = self.ReadIndex, self.Capacity do
			self[i] = nil
		end
	end
	
	self.Count      = 0
	self.ReadIndex  = 1
	self.WriteIndex = 1
end

function self:GetCapacity()
	return self.Capacity
end

function self:GetCount()
	return self.Count
end

function self:GetEnumerator()
	local i = 0
	return function()
		i = i + 1
		if i > self.Count then return nil end
		
		return self[(self.ReadIndex + i - 2) % self.Capacity + 1]
	end
end

function self:Get(i)
	if i > 0 then
		if i > self.Count then return nil end
		
		return self[(self.ReadIndex + i - 2) % self.Capacity + 1]
	elseif i < 0 then
		if -i > self.Count then return nil end
		
		return self[(self.WriteIndex + i - 1) % self.Capacity + 1]
	else
		return nil
	end
end

function self:Pop()
	if self.Count == 0 then return nil end
	
	local item = self[self.ReadIndex]
	self.ReadIndex = (self.ReadIndex % self.Capacity) + 1
	self.Count = self.Count - 1
	return item
end

function self:Push(x)
	self[self.WriteIndex] = x
	self.WriteIndex = (self.WriteIndex % self.Capacity) + 1
	
	if self.Count == self.Capacity then
		self.ReadIndex = self.WriteIndex
	else
		self.Count = self.Count + 1
	end
end

return CircularBuffer
