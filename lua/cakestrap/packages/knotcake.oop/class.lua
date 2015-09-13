local self = {}
OOP.Class = OOP.Class (self, OOP.Object)

function self:ctor (methodTable, firstBaseClass, ...)
	firstBaseClass = firstBaseClass or OOP.Object
	if firstBaseClass == self then
		firstBaseClass = nil
	end
	
	self.BaseClasses = { firstBaseClass, ... }
	self.MethodTable = methodTable
	self.MethodTable._Class = self
	
	if self.BaseClasses [1] then
		setmetatable (self.MethodTable, { __index = self.BaseClasses [1]:GetMethodTable () })
	end
	
	self.Metatable = {}
	self.Metatable.__index = self.MethodTable
	
	self.MetamethodsResolved = false
	
	self.FlattenedConstructor           = nil
	self.FlattenedDestructor            = nil
	self.FlattenedBaseClasses           = nil
	self.FlattenedBaseClassMethodTables = nil
end

function self:__call (...)
	-- Make instance
	local object = {}
	
	setmetatable (object, self:GetMetatable ())
	
	if not self.FlattenedConstructor then
		self.FlattenedConstructor = self:CreateFlattenedConstructor ()
	end
	
	if not self.FlattenedDestructor then
		self.FlattenedDestructor = self:CreateFlattenedDestructor ()
	end
	object.dtor = self.FlattenedDestructor
	
	self.FlattenedConstructor (object, ...)
	
	return object
end

function self:Assimilate (object)
	setmetatable (object, self:GetMetatable ())
	
	if not self.FlattenedDestructor then
		self.FlattenedDestructor = self:CreateFlattenedDestructor ()
	end
	object.dtor = self.FlattenedDestructor
end

function self:GetBaseClass (i)
	return self.BaseClasses [i or 1]
end

function self:GetBaseClassCount ()
	return #self.BaseClasses
end

function self:GetFlattenedConstructor ()
	if not self.FlattenedConstructor then
		self.FlattenedConstructor = self:CreateFlattenedConstructor ()
	end
	return self.FlattenedConstructor
end

function self:GetFlattenedDestructor ()
	if not self.FlattenedDestructor then
		self.FlattenedDestructor = self:CreateFlattenedDestructor ()
	end
	return self.FlattenedDestructor
end

function self:GetMetatable ()
	if not self.MetamethodsResolved then
		self:ResolveMetamethods ()
	end
	
	return self.Metatable
end

function self:GetMethodTable ()
	return self.MethodTable
end

-- Internal, do not call
function self:CreateFlattenedConstructor ()
	local constructorList = {}
	local flattenedBaseClasses = self:GetFlattenedBaseClasses ()
	for i = 1, #flattenedBaseClasses do
		constructorList [#constructorList + 1] = flattenedBaseClasses [i]:GetMethodTable ().ctor
	end
	
	return function (self, ...)
		for i = #constructorList, 1, -1 do
			constructorList [i] (self, ...)
		end
	end
end

function self:CreateFlattenedDestructor ()
	local destructorList = {}
	local flattenedBaseClasses = self:GetFlattenedBaseClasses ()
	for i = 1, #flattenedBaseClasses do
		destructorList [#destructorList + 1] = flattenedBaseClasses [i]:GetMethodTable ().dtor
	end
	
	return function (self, ...)
		for i = 1, #destructorList do
			destructorList [i] (self, ...)
		end
	end
end

function self:GetFlattenedBaseClasses ()
	if not self.FlattenedBaseClasses then
		self.FlattenedBaseClasses = {}
		
		OOP.Algorithms.DepthFirstSearch (
			self,
			function (class)
				local i = 0
				return function ()
					i = i + 1
					return class:GetBaseClass (i)
				end
			end,
			function (class)
				self.FlattenedBaseClasses [#self.FlattenedBaseClasses + 1] = class
			end
		)
	end
	
	return self.FlattenedBaseClasses
end

local metamethods =
{
	"__call"
}
function self:ResolveMetamethods ()
	local metatable = self.Metatable
	local baseClass = self:GetBaseClass ()
	local baseClassMetatable = baseClass and baseClass:GetMetatable ()
	
	for i = 1, #metamethods do
		if baseClassMetatable then
			if self.MethodTable [metamethods [i]] then
				metatable [metamethods [i]] = self.MethodTable [metamethods [i]]
			elseif baseClassMetatable then
				metatable [metamethods [i]] = baseClassMetatable [metamethods [i]]
			end
		end
	end
end