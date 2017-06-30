local Error = require ("Pylon.Error")
local OOP = require ("Pylon.OOP")
local ICollection = require ("Pylon.Containers.ICollection")

local self = {}
local ICollection = OOP.Interface (self)

function self:ctor ()
end

function self:Contains (x)
	return self:IndexOf (x) ~= nil
end

function self:GetCount ()
	Error ("ICollection:GetCount : Not implemented.")
end

function self:GetEnumerator ()
	Error ("ICollection:GetEnumerator : Not implemented.")
end

function self:IndexOf (x)
	local i = 1
	for item in self:GetEnumerator () do
		if item == x then return i end
		i = i + 1
	end
	
	return nil
end

function self:IsEmpty ()
	return self:GetCount () == 0
end

return ICollection
