local self = {}
OOP.Class = OOP.Class (self, OOP.Object)

function self:ctor (methodTable, firstBaseClass, ...)
	firstBaseClass = firstBaseClass or OOP.Object
	if firstBaseClass == self then
		firstBaseClass = nil
	end
	
	self.BaseClasses                          = { firstBaseClass, ... }
	
	self.MethodTable                          = methodTable
	self.FinalizedMethodTable                 = nil
	self.FlattenedMethodTable                 = nil
	
	self.Events                               = nil
	self.Properties                           = nil
	
	self.Metatable                            = nil
	
	self.FlattenedConstructor                 = nil
	self.FlattenedDestructor                  = nil
	self.FlattenedBaseClasses                 = nil
	
	self.AuxiliaryConstructorCreated          = false
	self.AuxiliaryConstructor                 = nil

	-- Properties
	self.PropertySerializer                   = nil
	self.PropertySerializerCreated            = nil
	self.PropertyDeserializer                 = nil
	self.PropertyDeserializerCreated          = nil
	self.PropertyCopier                       = nil
	self.PropertyCopierCreated                = nil
	
	self.FlattenedPropertySerializer          = nil
	self.FlattenedPropertySerializerCreated   = nil
	self.FlattenedPropertyDeserializer        = nil
	self.FlattenedPropertyDeserializerCreated = nil
	self.FlattenedPropertyCopier              = nil
	self.FlattenedPropertyCopierCreated       = nil
end

function self:__index (k)
	if k == "Methods" then
		return self:GetFinalizedMethodTable ()
	elseif k == "Serializer" and
	       self:IsDerivedFrom (OOP.ISerializable) then
		local serializer = OOP.SerializableSerializer (self)
		self.Serializer = serializer
		return serializer
	end
	
	return nil
end

function self:__call (...)
	return self:CreateInstance (...)
end

function self:Assimilate (object)
	setmetatable (object, self:GetMetatable ())
	
	if not self.FlattenedDestructor then
		self.FlattenedDestructor = self:CreateFlattenedDestructor ()
	end
	object.dtor = self.FlattenedDestructor
end

function self:CreateInstance (...)
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

function self:GetBaseClass (i)
	return self.BaseClasses [i or 1]
end

function self:GetBaseClassCount ()
	return #self.BaseClasses
end

function self:GetAuxiliaryConstructor ()
	if not self.AuxiliaryConstructorCreated then
		self.AuxiliaryConstructor = self:CreateAuxiliaryConstructor ()
		self.AuxiliaryConstructorCreated = true
	end
	
	return self.AuxiliaryConstructor
end

function self:GetFinalizedMethodTable ()
	if not self.FinalizedMethodTable then
		self.FinalizedMethodTable = self:CreateFinalizedMethodTable ()
	end
	
	return self.FinalizedMethodTable
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

function self:GetFlattenedMethodTable ()
	if not self.FlattenedMethodTable then
		self.FlattenedMethodTable = self:CreateFlattenedMethodTable ()
	end
	
	return self.FlattenedMethodTable
end

function self:GetMetatable ()
	if not self.Metatable then
		self.Metatable = self:CreateMetatable ()
	end
	
	return self.Metatable
end

function self:GetMethodTable ()
	return self.MethodTable
end

function self:GetPropertySerializer ()
	if not self.PropertySerializerCreated then
		self.PropertySerializer = self:CreatePropertySerializer ()
		self.PropertySerializerCreated = true
	end
	
	return self.PropertySerializer
end

function self:GetPropertyDeserializer ()
	if not self.PropertyDeserializerCreated then
		self.PropertyDeserializer = self:CreatePropertyDeserializer ()
		self.PropertyDeserializerCreated = true
	end
	
	return self.PropertyDeserializer
end

function self:GetPropertyCopier ()
	if not self.PropertyCopierCreated then
		self.PropertyCopier = self:CreatePropertyCopier ()
		self.PropertyCopierCreated = true
	end
	
	return self.PropertyCopier
end

function self:IsDerivedFrom (class)
	for _, baseClass in ipairs (self.BaseClasses) do
		if baseClass == class then return true end
		if baseClass:IsDerivedFrom (class) then return true end
	end
	
	return false
end

function self:IsInstance (object)
	if not istable (object) then return false end
	local class = object._Class
	if not class then return false end
	
	if class == self then return true end
	return class:IsDerivedFrom (self)
end

-- Internal, do not call
function self:CreateAuxiliaryConstructor ()
	local events                = {}
	local initializedProperties = {}
	
	for _, event in ipairs (self:GetEvents ()) do
		events [event:GetName ()] = event
	end
	
	for _, property in ipairs (self:GetProperties ()) do
		if property:IsEvented () then
			local eventName = property:GetName () .. "Changed"
			events [eventName] = OOP.Event ():SetName (eventName)
			events ["Changed"] = events ["Changed"] or OOP.Event ():SetName ("Changed")
		end
		if property:GetInitialValue () ~= nil then
			initializedProperties [#initializedProperties + 1] = property
		end
	end
	
	if not next (events) and #initializedProperties == 0 then return nil end
	
	return function (self, ...)
		for eventName, event in pairs (events) do
			self [eventName] = event:Clone ()
		end
		
		for i = 1, #initializedProperties do
			local propertyName = initializedProperties [i]:GetName ()
			local initialValue = initializedProperties [i]:GetInitialValue ()
			self [propertyName] = initialValue
		end
	end
end

function self:CreateFinalizedMethodTable ()
	local finalizedMethodTable = {}
	
	if self.BaseClasses [1] then
		setmetatable (finalizedMethodTable, { __index = self.BaseClasses [1]:GetFinalizedMethodTable () })
	end
	
	-- This class
	finalizedMethodTable._Class = self
	
	-- Properties
	local properties = self:GetProperties ()
	if #properties > 0 then
		for i = 1, #properties do
			local property = properties [i]
			finalizedMethodTable [property:GetGetterName ()] = property:GetGetter ()
			finalizedMethodTable [property:GetSetterName ()] = property:GetSetter ()
		end
		
		finalizedMethodTable.SerializeProperties   = self:GetFlattenedPropertySerializer   ()
		finalizedMethodTable.DeserializeProperties = self:GetFlattenedPropertyDeserializer ()
		finalizedMethodTable.CopyProperties        = self:GetFlattenedPropertyCopier       ()
		
		if OOP.ISerializable and self:IsDerivedFrom (OOP.ISerializable) then
			finalizedMethodTable.Serialize = function (self, streamWriter)
				return self:SerializeProperties (streamWriter)
			end
			
			finalizedMethodTable.Deserialize = function (self, streamReader)
				return self:DeserializeProperties (streamReader)
			end
		end
		
		if OOP.ICloneable and self:IsDerivedFrom (OOP.ICloneable) then
			finalizedMethodTable.Copy = function (self, source)
				return self:CopyProperties (source)
			end
		end
	end
	
	for methodName, method in pairs (self:GetMethodTable ()) do
		if OOP.Event and OOP.Event:IsInstance (method) then
		elseif OOP.Property and OOP.Property:IsInstance (method) then
		else
			finalizedMethodTable [methodName] = method
		end
	end
	
	-- Other base classes
	for i = #self.BaseClasses, 2, -1 do
		for methodName, method in pairs (self.BaseClasses [i]:GetFlattenedMethodTable ()) do
			if not finalizedMethodTable [methodName] then
				finalizedMethodTable [methodName] = method
			end
		end
	end
	
	return finalizedMethodTable
end

function self:CreateFlattenedConstructor ()
	local constructorList = {}
	local flattenedBaseClasses = self:GetFlattenedBaseClasses ()
	for i = 1, #flattenedBaseClasses do
		constructorList [#constructorList + 1] = flattenedBaseClasses [i]:GetAuxiliaryConstructor ()
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

function self:CreateFlattenedMethodTable ()
	local flattenedMethodTable = {}
	
	for i = #self.BaseClasses, 1, -1 do
		for methodName, method in pairs (self.BaseClasses [i]:GetFlattenedMethodTable ()) do
			flattenedMethodTable [methodName] = method
		end
	end
	
	for methodName, method in pairs (self:GetFinalizedMethodTable ()) do
		flattenedMethodTable [methodName] = method
	end
	
	return flattenedMethodTable
end

function self:CreateFlattenedPropertySerializer ()
	local propertySerializerList = {}
	local flattenedBaseClasses = self:GetFlattenedBaseClasses ()
	for i = #flattenedBaseClasses, 1, -1 do
		propertySerializerList [#propertySerializerList + 1] = flattenedBaseClasses [i]:GetPropertySerializer ()
	end
	
	if #propertySerializerList == 0 then return nil end
	
	return function (self, streamWriter)
		for i = 1, #propertySerializerList do
			propertySerializerList [i] (self, streamWriter)
		end
		
		return streamWriter
	end
end

function self:CreateFlattenedPropertyDeserializer ()
	local propertyDeserializerList = {}
	local flattenedBaseClasses = self:GetFlattenedBaseClasses ()
	for i = #flattenedBaseClasses, 1, -1 do
		propertyDeserializerList [#propertyDeserializerList + 1] = flattenedBaseClasses [i]:GetPropertyDeserializer ()
	end
	
	if #propertyDeserializerList == 0 then return nil end
	
	return function (self, streamReader)
		for i = 1, #propertyDeserializerList do
			propertyDeserializerList [i] (self, streamReader)
		end
		
		return self
	end
end

function self:CreateFlattenedPropertyCopier ()
	local propertyCopierList = {}
	local flattenedBaseClasses = self:GetFlattenedBaseClasses ()
	for i = #flattenedBaseClasses, 1, -1 do
		propertyCopierList [#propertyCopierList + 1] = flattenedBaseClasses [i]:GetPropertyCopier ()
	end
	
	if #propertyCopierList == 0 then return nil end
	
	return function (self, source)
		for i = 1, #propertyCopierList do
			propertyCopierList [i] (self, source)
		end
		
		return self
	end
end

function self:CreateMetatable ()
	local finalizedMethodTable = self:GetFinalizedMethodTable ()
	
	local metatable = {}
	metatable.__index = finalizedMethodTable
	
	if finalizedMethodTable.__index then
		metatable.__index = function (self, k)
			local v = finalizedMethodTable [k]
			if v ~= nil then return v end
			
			return finalizedMethodTable.__index (self, k)
		end
	end
	
	self:ResolveMetamethods (metatable)
	
	return metatable
end

function self:CreatePropertySerializer ()
	local properties = self:GetProperties ()
	if #properties == 0 then return nil end
	
	return function (self, streamWriter)
		for i = 1, #properties do
			local property = properties [i]
			local value = self [property:GetGetterName ()] (self)
			if property:IsNullable () then
				streamWriter:Boolean (value ~= nil)
				if value ~= nil then
					streamWriter [property:GetType ()] (streamWriter, value)
				end
			else
				streamWriter [property:GetType ()] (streamWriter, value)
			end
		end
		
		return streamWriter
	end
end

function self:CreatePropertyDeserializer ()
	local properties = self:GetProperties ()
	if #properties == 0 then return nil end
	
	return function (self, streamReader)
		for i = 1, #properties do
			local property = properties [i]
			if property:IsNullable () then
				if streamReader:Boolean () then
					self [property:GetSetterName ()] (self, streamReader [property:GetType ()] (streamReader))
				end
			else
				self [property:GetSetterName ()] (self, streamReader [property:GetType ()] (streamReader))
			end
		end
		
		return self
	end
end

function self:CreatePropertyCopier ()
	local properties = self:GetProperties ()
	if #properties == 0 then return nil end
	
	return function (self, source)
		for i = 1, #properties do
			local property = properties [i]
			self [property:GetSetterName ()] (self, source [property:GetGetterName ()] (source))
		end
		
		return self
	end
end

function self:GetEvents ()
	if not self.Events then
		self.Events = {}
		
		for k, v in pairs (self:GetMethodTable ()) do
			if OOP.Event and OOP.Event:IsInstance (v) then
				v:SetName (k)
				self.Events [#self.Events + 1] = v
			end
		end
	end
	
	return self.Events
end

function self:GetFlattenedBaseClasses ()
	if not self.FlattenedBaseClasses then
		self.FlattenedBaseClasses = {}
		
		Algorithms.DepthFirstSearch (
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

function self:GetFlattenedPropertySerializer ()
	if not self.FlattenedPropertySerializerCreated then
		self.FlattenedPropertySerializer = self:CreateFlattenedPropertySerializer ()
		self.FlattenedPropertySerializerCreated = true
	end
	
	return self.FlattenedPropertySerializer
end

function self:GetFlattenedPropertyDeserializer ()
	if not self.FlattenedPropertyDeserializerCreated then
		self.FlattenedPropertyDeserializer = self:CreateFlattenedPropertyDeserializer ()
		self.FlattenedPropertyDeserializerCreated = true
	end
	
	return self.FlattenedPropertyDeserializer
end

function self:GetFlattenedPropertyCopier ()
	if not self.FlattenedPropertyCopierCreated then
		self.FlattenedPropertyCopier = self:CreateFlattenedPropertyCopier ()
		self.FlattenedPropertyCopierCreated = true
	end
	
	return self.FlattenedPropertyCopier
end

function self:GetProperties ()
	if not self.Properties then
		self.Properties = {}
		
		for k, v in pairs (self:GetMethodTable ()) do
			if OOP.Property and OOP.Property:IsInstance (v) then
				v:SetName (k)
				self.Properties [#self.Properties + 1] = v
			end
		end
		
		table.sort (self.Properties,
			function (a, b)
				return a:GetInstanceId () < b:GetInstanceId ()
			end
		)
	end
	
	return self.Properties
end

local metamethods =
{
	"__call"
}
function self:ResolveMetamethods (metatable)
	local baseClass = self:GetBaseClass ()
	local baseClassMetatable = baseClass and baseClass:GetMetatable ()
	
	for i = 1, #metamethods do
		local metamethodName = metamethods [i]
		
		if self.MethodTable [metamethodName] then
			metatable [metamethodName] = self.MethodTable [metamethodName]
		else
			for _, baseClass in ipairs (self.BaseClasses) do
				local baseClassMetatable = baseClass:GetMetatable ()
				if baseClassMetatable [metamethodName] then
					metatable [metamethodName] = baseClassMetatable [metamethodName]
					break
				end
			end
		end
	end
	
	return metatable
end
