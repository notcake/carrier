function OOP.Class (methodTable)
	return function (...)
		local object = {}
		setmetatable (object,
			{
				__index = methodTable,
				__call  = methodTable.__call
			}
		)
		
		object:ctor (...)
		
		return object
	end
end

local self = {}
OOP.Class = OOP.Class (self, OOP.Object)

function self:ctor (methodTable, ...)
	self.BaseClasses = { ... }
	self.MethodTable = methodTable
	
	self.Metatable = {}
	self.Metatable.__index = self.MethodTable
	
	self.FlattenedConstructor = nil
	self.FlattenedDestructor  = nil
end

function self:__call (...)
	-- Make instance
	local object = {}
	
	if not self.FlattenedConstructor then
		self:CreateFlattenedConstructor ()
	end
	self.FlattenedConstructor (object, ...)
	
	return object
end

function self:GetBaseClass (i)
	return self.BaseClasses [i or 1]
end

function self:GetBaseClassCount ()
	return #self.BaseClasses
end

function self:GetMethodTable ()
	return self.MethodTable
end

-- Internal, do not call
function self:CreateFlattenedConstructor ()
end

OOP.Class = OOP.Class (self)