-- BEGIN CARRIER BOOTSTRAP



local Error = error

local Algorithms = {}
function Algorithms.DepthFirstSearch (startingNode, edgeEnumeratorFactory, preOrderNodeSink, postOrderNodeSink)
	local visitedNodes = {}
	local function DepthFirstSearch (startingNode, edgeEnumeratorFactory, preOrderNodeSink, postOrderNodeSink, visitedNodes)
		if preOrderNodeSink then preOrderNodeSink (startingNode) end
		visitedNodes [startingNode] = true
		
		for node in edgeEnumeratorFactory (startingNode) do
			if not visitedNodes [node] then
				DepthFirstSearch (node, edgeEnumeratorFactory, preOrderNodeSink, postOrderNodeSink, visitedNodes)
			end
		end
		if postOrderNodeSink then postOrderNodeSink (startingNode) end
	end
	
	DepthFirstSearch (startingNode, edgeEnumeratorFactory, preOrderNodeSink, postOrderNodeSink, visitedNodes)
end

function Algorithms.DepthFirstSearchPreOrder (startingNode, edgeEnumeratorFactory, nodeSink)
	Algorithms.DepthFirstSearch (startingNode, edgeEnumeratorFactory, nodeSink, nil)
end

function Algorithms.DepthFirstSearchPostOrder (startingNode, edgeEnumeratorFactory, nodeSink)
	Algorithms.DepthFirstSearch (startingNode, edgeEnumeratorFactory, nil, nodeSink)
end


local OOP = {}
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

function self:ctor (methodTable, firstBaseClass, ...)
	firstBaseClass = firstBaseClass or OOP.Object
	if firstBaseClass == self then
		firstBaseClass = nil
	end
	
	self.BaseClasses                          = { firstBaseClass, ... }
	
	self.MethodTable                          = methodTable
	self.FinalizedMethodTable                 = nil
	self.FinalizedMethodTableSources          = nil
	self.FlattenedMethodTable                 = nil
	self.FlattenedMethodTableSources          = nil
	
	self.Events                               = nil
	self.Properties                           = nil
	
	self.Metatable                            = nil
	
	self.FlattenedConstructor                 = nil
	self.FlattenedDestructor                  = nil
	self.FlattenedBaseClasses                 = nil
	
	self.AuxiliaryConstructorCreated          = false
	self.AuxiliaryConstructor                 = nil
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
		self.FinalizedMethodTable, self.FinalizedMethodTableSources = self:CreateFinalizedMethodTable ()
	end
	
	return self.FinalizedMethodTable, self.FinalizedMethodTableSources
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
		self.FlattenedMethodTable, self.FlattenedMethodTableSources = self:CreateFlattenedMethodTable ()
	end
	
	return self.FlattenedMethodTable, self.FlattenedMethodTableSources
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
	if type (object) ~= "table" then return false end
	local class = object._Class
	if not class then return false end
	
	if class == self then return true end
	return class:IsDerivedFrom (self)
end
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
			self [eventName] = OOP.Event ()
		end
		
		for i = 1, #initializedProperties do
			local propertyName = initializedProperties [i]:GetName ()
			local initialValue = initializedProperties [i]:GetInitialValue ()
			self [propertyName] = initialValue
		end
	end
end

function self:CreateFinalizedMethodTable ()
	local finalizedMethodTable        = {}
	local finalizedMethodTableSources = {}
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
	for methodName, _ in pairs (finalizedMethodTable) do
		finalizedMethodTableSources [methodName] = self
	end
	finalizedMethodTable._Class = self
	finalizedMethodTableSources._Class = self
	if #self.BaseClasses >= 2 then
		local baseFlattenedMethodTable0, baseFlattenedMethodTableSources0 = self.BaseClasses [1]:GetFlattenedMethodTable ()
		for i = #self.BaseClasses, 2, -1 do
			local baseFlattenedMethodTable1, baseFlattenedMethodTableSources1 = self.BaseClasses [i]:GetFlattenedMethodTable ()
			for methodName, method in pairs (baseFlattenedMethodTable1) do
				if not finalizedMethodTable [methodName] then
					local shouldOverride = not baseFlattenedMethodTableSources0 [methodName]
					if not shouldOverride then
						local source0 = baseFlattenedMethodTableSources0 [methodName]
						local source1 = baseFlattenedMethodTableSources1 [methodName]
						shouldOverride = source0 ~= source1 and source1:GetFlattenedBaseClasses () [source0]
					end
					if shouldOverride then
						finalizedMethodTable [methodName] = method
						finalizedMethodTableSources [methodName] = baseFlattenedMethodTableSources1 [methodName]
					end
				end
			end
		end
	end
	if self.BaseClasses [1] then
		setmetatable (finalizedMethodTable, { __index = self.BaseClasses [1]:GetFinalizedMethodTable () })
	end
	
	return finalizedMethodTable, finalizedMethodTableSources
end

function self:CreateFlattenedConstructor ()
	local constructorList = {}
	local flattenedBaseClasses = self:GetFlattenedBaseClasses ()
	for i = 1, #flattenedBaseClasses do
		constructorList [#constructorList + 1] = flattenedBaseClasses [i]:GetAuxiliaryConstructor ()
		constructorList [#constructorList + 1] = flattenedBaseClasses [i]:GetMethodTable ().ctor
	end
	
	return function (self, ...)
		for i = 1, #constructorList do
			constructorList [i] (self, ...)
		end
	end
end

function self:CreateFlattenedDestructor ()
	local destructorList = {}
	local flattenedBaseClasses = self:GetFlattenedBaseClasses ()
	for i = #flattenedBaseClasses, 1, -1 do
		destructorList [#destructorList + 1] = flattenedBaseClasses [i]:GetMethodTable ().dtor
	end
	
	return function (self, ...)
		for i = 1, #destructorList do
			destructorList [i] (self, ...)
		end
	end
end

function self:CreateFlattenedMethodTable ()
	local flattenedMethodTable        = {}
	local flattenedMethodTableSources = {}
	
	for i = #self.BaseClasses, 1, -1 do
		local baseFlattenedMethodTable, baseFlattenedMethodTableSources = self.BaseClasses [i]:GetFlattenedMethodTable ()
		for methodName, method in pairs (baseFlattenedMethodTable) do
			flattenedMethodTable [methodName] = method
			flattenedMethodTableSources [methodName] = baseFlattenedMethodTableSources [methodName]
		end
	end
	
	local finalizedMethodTable, finalizedMethodTableSources = self:GetFinalizedMethodTable ()
	for methodName, method in pairs (finalizedMethodTable) do
		flattenedMethodTable [methodName] = method
		flattenedMethodTableSources [methodName] = finalizedMethodTableSources [methodName]
	end
	
	return flattenedMethodTable, flattenedMethodTableSources
end

function self:CreateFlattenedPropertySerializer ()
	local propertySerializerList = {}
	local flattenedBaseClasses = self:GetFlattenedBaseClasses ()
	for i = 1, #flattenedBaseClasses do
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
	for i = 1, #flattenedBaseClasses do
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
	for i = 1, #flattenedBaseClasses do
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
		
		Algorithms.DepthFirstSearchPostOrder (
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
				self.FlattenedBaseClasses [class] = true
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
	"__call",
	"__tostring",
	"__unm",
	"__add",
	"__sub",
	"__mul",
	"__div",
	"__mod",
	"__pow",
	"__eq",
	"__lt",
	"__le"
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

local self = {}
OOP.Enum = OOP.Class (self)

function self:ctor (enum)
	if not next (enum) then
		Error ("Pylon.OOP.Enum : This enum appears to be empty!")
	end
	
	self.Names = {}
	
	for key, value in pairs (enum) do
		self [key] = value
		self.Names [value] = key
	end
end

function self:GetName (value)
	return self.Names [value]
end

function self:ToString (value)
	return self.Names [value] or string.format ("0x%08x", value)
end

local Class     = OOP.Class
local Enum      = OOP.Enum
local Interface = Class



local CompactList = {}

local select = select
local unpack = unpack

function CompactList.Append (n, data, x)
	if n == 0 then
		return 1, x
	elseif n == 1 then
		return 2, { data, x }
	else
		data [n + 1] = x
		return n + 1, data
	end
end

function CompactList.Clear (n, data)
	return 0, nil
end

function CompactList.Count (n, data)
	return n
end

function CompactList.Enumerator (n, data)
	if n == 0 then
		return function () return nil end
	elseif n == 1 then
		local i = 0
		return function ()
			i = i + 1
			return i == 1 and data or nil
		end
	else
		local i = 0
		return function ()
			i = i + 1
			return data [i]
		end
	end
end

function CompactList.Get (n, data, i)
	if n == 0 then
		return nil
	elseif n == 1 then
		return i == 1 and data or nil
	else
		return data [i]
	end
end

function CompactList.Pack (...)
	local n = select ("#", ...)
	if n == 0 then
		return 0, nil
	elseif n == 1 then
		local first = ...
		return n, first
	else
		return n, { ... }
	end
end

function CompactList.Unpack (n, data)
	if n == 0 then
		return
	elseif n == 1 then
		return data
	else
		return unpack (data, 1, n)
	end
end

local CompactList = CompactList
local Enumeration = {}
local EnumeratorFunction = {}
function EnumeratorFunction:RegisterFunction (f) return f end
local pairs = pairs

local coroutine_create = coroutine.create
local coroutine_resume = coroutine.resume
local coroutine_status = coroutine.status

function Enumeration.ArrayEnumerator (tbl)
	local i = 0
	return EnumeratorFunction:RegisterFunction (
		function ()
			i = i + 1
			return tbl [i]
		end
	)
end

function Enumeration.KeyEnumerator (tbl)
	local next, tbl, key = pairs (tbl)
	return EnumeratorFunction:RegisterFunction (
		function ()
			key = next (tbl, key)
			return key
		end
	)
end

function Enumeration.ValueEnumerator (tbl)
	local next, tbl, key = pairs (tbl)
	return EnumeratorFunction:RegisterFunction (
		function ()
			key = next (tbl, key)
			return tbl [key]
		end
	)
end

function Enumeration.KeyValueEnumerator (tbl)
	local next, tbl, key = pairs (tbl)
	return EnumeratorFunction:RegisterFunction (
		function ()
			key = next (tbl, key)
			return key, tbl [key]
		end
	)
end

function Enumeration.ValueKeyEnumerator (tbl)
	local next, tbl, key = pairs (tbl)
	return EnumeratorFunction:RegisterFunction (
		function ()
			key = next (tbl, key)
			return tbl [key], key
		end
	)
end

function Enumeration.NullEnumerator ()
	return EnumeratorFunction:RegisterFunction (
		function ()
			return nil
		end
	)
end

function Enumeration.SingleValueEnumerator (v)
	local done = false
	return EnumeratorFunction:RegisterFunction (
		function ()
			if done then return nil end
			done = true
			return v
		end
	)
end

function Enumeration.YieldEnumerator (f, ...)
	local argumentCount, arguments = CompactList.Pack (...)
	argumentCount, arguments = CompactList.Append (argumentCount, arguments, coroutine.yield)
	
	local thread = coroutine_create (
		function ()
			return f (CompactList.Unpack (argumentCount, arguments))
		end
	)
	return EnumeratorFunction:RegisterFunction (
		function ()
			if coroutine_status (thread) == "dead" then return nil end
			
			return (
				function (success, ...)
					if not success then
						Error (...)
						return nil
					end
					
					return ...
				end
			) (coroutine_resume (thread))
		end
	)
end

function Enumeration.YieldEnumeratorFactory (f)
	return function (...)
		return Enumeration.YieldEnumerator (f, ...)
	end
end

local ValueEnumerator = Enumeration.ValueEnumerator
local KeyValueEnumerator = Enumeration.KeyValueEnumerator





local self = {}
local Future = OOP.Class (self)

function self:ctor ()
	self.Resolved = false
	
	self.ReturnCount, self.Returns = CompactList.Clear ()
	self.WaiterCount, self.Waiters = CompactList.Clear ()
end

function self:Map (f)
	local future = Future ()
	self:Wait (
		function (...)
			future:Resolve (f (...))
		end
	)
	return future
end

function self:FlatMap (f)
	local future = Future ()
	self:Wait (
		function (...)
			f (...):Wait (
				function (...)
					future:Resolve (...)
				end
			)
		end
	)
	return future
end
self.MapAsync = self.FlatMap

function self:Resolve (...)
	assert (not self.Resolved, "Future resolved twice!")
	
	self.Resolved = true
	self.ReturnCount, self.Returns = CompactList.Pack (...)
	
	for f in CompactList.Enumerator (self.WaiterCount, self.Waiters) do
		f (CompactList.Unpack (self.ReturnCount, self.Returns))
	end
	
	self.WaiterCount, self.Waiters = CompactList.Clear (self.WaiterCount, self.Waiters)
end

function self:Wait (f)
	if self.Resolved then
		f (CompactList.Unpack (self.ReturnCount, self.Returns))
	else
		self.WaiterCount, self.Waiters = CompactList.Append (self.WaiterCount, self.Waiters, f)
	end
end

function self:Await ()
	if self.Resolved then
		return CompactList.Unpack (self.ReturnCount, self.Returns)
	else
		local thread = coroutine.running ()
		self:Wait (
			function (...)
				coroutine.resume (thread, ...)
			end
		)
	end
	
	return coroutine.yield ()
end

self.map      = self.Map
self.flatMap  = self.FlatMap
self.mapAsync = self.MapAsync
self.resolve  = self.Resolve
self.await    = self.Await
self.wait     = self.Wait

function Future.Resolved (...)
	local future = Future ()
	future:Resolve (...)
	return future
end

function Future.Join (...)
	local count = select ("#", ...)
	return Future.JoinArray ({...}):Map (
		function (array)
			return unpack (array, 1, count)
		end
	)
end

function Future.JoinArray (array)
	local count = #array
	if count == 0 then return Future.resolved () end
	
	local future = Future ()
	local results = {}
	local i = 0
	for k, f in ipairs (array) do
		f:Wait (
			function (...)
				results[k] = select ("#", ...) > 1 and {...} or ...
			
				i = i + 1
				if i == count then
					future:Resolve (results)
				end
			end
		)
	end
	return future
end

Future.resolved  = Future.Resolved
Future.join      = Future.Join
Future.JoinArray = Future.JoinArray

local Future = Future


local Functional = {}

function Functional.Curry (f, x)
	return function (...)
		return f (x, ...)
	end
end

Functional.curry = Functional.Curry

local Functional = Functional
local f = Functional


local Task = {}



function Task.RunCallback (f, ...)
	local argumentCount, arguments = CompactList.Pack (...)
	local future = Future ()
	argumentCount, arguments = CompactList.Append (argumentCount, arguments,
		function (...)
			future:Resolve (...)
		end
	)
	
	f (CompactList.Unpack (argumentCount, arguments))
	
	return future
	
end

Task.WrapCallback = f.Curry (f.Curry, Task.RunCallback)

function Task.Run (f, ...)
	local future = Future ()
	
	coroutine.wrap (
		function (...)
			local success, err = xpcall (
				function (...)
					future:Resolve (f (...))
				end,
				debug.traceback,
				...
			)
			if not success then
				print (err)
				future:Resolve (nil)
			end
		end
	) (...)
	
	return future
end

Task.Wrap = f.Curry (f.Curry, Task.Run)

local Task = Task

local HTTP = {}
function HTTP.Initialize () end
local encodeMap = {}
local decodeMap = {}
for i = 0, 255 do
	encodeMap [string.char (i)] = string.format ("%%%02X", i)
	decodeMap [string.format ("%%%02x", i)] = string.char (i)
	decodeMap [string.format ("%%%02X", i)] = string.char (i)
end
function HTTP.EncodeUriComponent (s)
	return string.gsub (s, "[^A-Za-z0-9%-_%.!~%*'%(%)]", encodeMap)
end
HTTP.HTTPCodes = {}
function HTTP.HTTPCodes.ToMessage () return "" end
local self = {}
HTTP.HTTPResponse = Class (self)

function HTTP.HTTPResponse.FromHTTPResponse (url, code, content, headers)
	local httpResponse = HTTP.HTTPResponse (url, code)
	
	httpResponse.Message = HTTP.HTTPCodes.ToMessage (code) or ""
	httpResponse.Content = content
	httpResponse.Headers = headers or {}
	
	return httpResponse
end

function HTTP.HTTPResponse.FromFailure (url, message)
	local httpResponse = HTTP.HTTPResponse (url, nil)
	
	httpResponse.Message = message
	
	return httpResponse
end

function self:ctor (url, code)
	self.Url     = url
	self.Code    = code
	self.Message = nil
	self.Content = nil
	
	self.Headers = {}
end

function self:GetUrl ()
	return self.Url
end

function self:GetCode ()
	return self.Code
end

function self:GetContent ()
	return self.Content
end

function self:GetContentLength ()
	if self.Content == nil then return 0 end
	
	return #self.Content
end

function self:GetMessage ()
	return self.Message
end

function self:IsSuccess ()
	return self.Code == 200
end



local GarrysMod = {}

HTTP.Initialize (GarrysMod)


function GarrysMod.Get (url)
	local future = Future ()
	http.Fetch (url,
		function (content, contentLength, headers, code)
			local response = HTTP.HTTPResponse.FromHTTPResponse (url, code, content, headers)
			future:Resolve (response)
		end,
		function (error)
			local response = HTTP.HTTPResponse.FromFailure (url, error)
			future:Resolve (response)
		end
	)
	return future
end

function GarrysMod.Post (url, parameters)
	local future = Future ()
	http.Post (url, parameters,
		function (content, contentLength, headers, code)
			local response = HTTP.HTTPResponse.FromHTTPResponse (url, code, content, headers)
			future:Resolve (response)
		end,
		function (error)
			local response = HTTP.HTTPResponse.FromFailure (url, error)
			future:Resolve (response)
		end
	)
	return future
end

local GarrysMod = GarrysMod
HTTP.Get  = GarrysMod.Get
HTTP.Post = GarrysMod.Post

local Crypto = {}
local self = {}
Crypto.SHA256 = Class (self)

local bit_band      = bit.band
local bit_bnot      = bit.bnot
local bit_bxor      = bit.bxor
local bit_lshift    = bit.lshift
local bit_ror       = bit.ror
local bit_rshift    = bit.rshift
local bit_tobit     = bit.tobit
local math_floor    = math.floor
local string_byte   = string.byte
local string_format = string.format

function Crypto.SHA256.Compute (x)
	return Crypto.SHA256 ():Update (x):Finish ()
end

function self:ctor ()
	self.State = { 0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19 }
	
	self.Length = 0
	self.Buffer = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
end

local blockSize = 16
function self:Update (data)
	if #data == 0 then return self end
	
	local dataLength = #data
	local bufferIndex = math_floor (self.Length / 4) % blockSize + 1
	local index = ((4 - self.Length) % 4) + 1
	if index == 1 then
	elseif index == 2 then
		local a = string_byte (data, 1)
		self.Buffer [bufferIndex] = self.Buffer [bufferIndex] +
		                             (a or 0) * 0x00000001
		if #data >= 1 then bufferIndex = bufferIndex + 1 end
	elseif index == 3 then
		local a, b = string_byte (data, 1, 2)
		self.Buffer [bufferIndex] = self.Buffer [bufferIndex] +
		                             (a or 0) * 0x00000100 +
		                             (b or 0) * 0x00000001
		if #data >= 2 then bufferIndex = bufferIndex + 1 end
	elseif index == 4 then
		local a, b, c = string_byte (data, 1, 3)
		self.Buffer [bufferIndex] = self.Buffer [bufferIndex] +
		                             (a or 0) * 0x00010000 +
		                             (b or 0) * 0x00000100 +
		                             (c or 0) * 0x00000001
		if #data >= 3 then bufferIndex = bufferIndex + 1 end
	end
	while #data - index + 1 >= (blockSize - bufferIndex + 1) * 4 do
		for i = bufferIndex, blockSize do
			local a, b, c, d = string_byte (data, index, index + 3)
			self.Buffer [i] = a * 0x01000000 + b * 0x00010000 + c * 0x00000100 + d
			index = index + 4
		end
		
		self:Block (self.Buffer)
		bufferIndex = 1
	end
	while index <= #data - 3 do
		local a, b, c, d = string_byte (data, index, index + 3)
		self.Buffer [bufferIndex] = a * 0x01000000 + b * 0x00010000 + c * 0x00000100 + d
		bufferIndex = bufferIndex + 1
		index = index + 4
	end
	
	if index <= #data then
		local a, b, c = string_byte (data, index, index + 2)
		self.Buffer [bufferIndex] = a * 0x01000000 + (b or 0) * 0x00010000 + (c or 0) * 0x00000100
	end
	
	self.Length = self.Length + #data
	return self
end

function self:Finish ()
	local bufferIndex = math_floor (self.Length / 4) % blockSize + 1
	local bytesFilled = self.Length % 4
	if bytesFilled == 0 then
		self.Buffer [bufferIndex] = 0x80000000
	elseif bytesFilled == 1 then
		self.Buffer [bufferIndex] = self.Buffer [bufferIndex] + 0x00800000
	elseif bytesFilled == 2 then
		self.Buffer [bufferIndex] = self.Buffer [bufferIndex] + 0x00008000
	elseif bytesFilled == 3 then
		self.Buffer [bufferIndex] = self.Buffer [bufferIndex] + 0x00000080
	end
	bufferIndex = bufferIndex + 1
	for i = bufferIndex, blockSize do
		self.Buffer [i] = 0
	end
	
	if blockSize - bufferIndex + 1 < 2 then
		self:Block (self.Buffer)
		bufferIndex = 1
		
		for i = 1, blockSize do
			self.Buffer [i] = 0
		end
	end
	
	self.Buffer [blockSize - 1] = math_floor ((self.Length * 8) / 4294967296)
	self.Buffer [blockSize]     = (self.Length * 8) % 4294967296
	self:Block (self.Buffer)
	
	return string_format ("%08x%08x%08x%08x%08x%08x%08x%08x", self.State [1] % 4294967296, self.State [2] % 4294967296, self.State [3] % 4294967296, self.State [4] % 4294967296, self.State [5] % 4294967296, self.State [6] % 4294967296, self.State [7] % 4294967296, self.State [8] % 4294967296)
end
local K =
{
	0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
	0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
	0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
	0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
	0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
	0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
	0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
	0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
}
local w = {}
function self:Block (block)
	for i = 1, blockSize do
		w [i] = block [i]
	end
	
	for i = 17, 64 do
		local s0 = bit_bxor (bit_ror (w [i - 15],  7), bit_ror (w [i - 15], 18), bit_rshift (w [i - 15],  3))
		local s1 = bit_bxor (bit_ror (w [i -  2], 17), bit_ror (w [i -  2], 19), bit_rshift (w [i -  2], 10))
		w [i] = w [i - 16] + s0 + w [i - 7] + s1
	end
	
	local h0, h1, h2, h3, h4, h5, h6, h7 = self.State [1], self.State [2], self.State [3], self.State [4], self.State [5], self.State [6], self.State [7], self.State [8]
	
	for i = 1, 64 do
		local S1 = bit_bxor (bit_ror (h4, 6), bit_ror (h4, 11), bit_ror (h4, 25))
		local ch = bit_bxor (bit_band (h4, h5), bit_band (bit_bnot (h4), h6))
		local temp1 = bit_tobit (h7 + S1 + ch + bit_tobit (K [i] + w [i]))
		local S0 = bit_bxor (bit_ror (h0, 2), bit_ror (h0, 13), bit_ror (h0, 22))
		local maj = bit_bxor (bit_band (h0, h1), bit_band (h0, h2), bit_band (h1, h2))
		local temp2 = S0 + maj
		
		h7 = h6
		h6 = h5
		h5 = h4
		h4 = h3 + temp1
		h3 = h2
		h2 = h1
		h1 = h0
		h0 = temp1 + temp2
	end
	
	self.State [1], self.State [2], self.State [3], self.State [4], self.State [5], self.State [6], self.State [7], self.State [8] = self.State [1] + h0, self.State [2] + h1, self.State [3] + h2, self.State [4] + h3, self.State [5] + h4, self.State [6] + h5, self.State [7] + h6, self.State [8] + h7
end

local self = {}
Crypto.MD5 = Class (self)

local bit_band      = bit.band
local bit_bnot      = bit.bnot
local bit_bor       = bit.bor
local bit_bswap     = bit.bswap
local bit_bxor      = bit.bxor
local bit_rol       = bit.rol
local bit_tobit     = bit.tobit
local math_floor    = math.floor
local string_byte   = string.byte
local string_format = string.format

function Crypto.MD5.Compute (x)
	return Crypto.MD5 ():Update (x):Finish ()
end

function self:ctor ()
	self.A, self.B, self.C, self.D = 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476
	
	self.Length = 0
	self.Buffer = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
end

local blockSize = 16
function self:Update (data)
	if #data == 0 then return self end
	
	local dataLength = #data
	local bufferIndex = math_floor (self.Length / 4) % blockSize + 1
	local index = ((4 - self.Length) % 4) + 1
	if index == 1 then
	elseif index == 2 then
		local a = string_byte (data, 1)
		self.Buffer [bufferIndex] = self.Buffer [bufferIndex] +
		                             (a or 0) * 0x01000000
		if #data >= 1 then bufferIndex = bufferIndex + 1 end
	elseif index == 3 then
		local a, b = string_byte (data, 1, 2)
		self.Buffer [bufferIndex] = self.Buffer [bufferIndex] +
		                             (a or 0) * 0x00010000 +
		                             (b or 0) * 0x01000000
		if #data >= 2 then bufferIndex = bufferIndex + 1 end
	elseif index == 4 then
		local a, b, c = string_byte (data, 1, 3)
		self.Buffer [bufferIndex] = self.Buffer [bufferIndex] +
		                             (a or 0) * 0x00000100 +
		                             (b or 0) * 0x00010000 +
		                             (c or 0) * 0x01000000
		if #data >= 3 then bufferIndex = bufferIndex + 1 end
	end
	while #data - index + 1 >= (blockSize - bufferIndex + 1) * 4 do
		for i = bufferIndex, blockSize do
			local a, b, c, d = string_byte (data, index, index + 3)
			self.Buffer [i] = a + b * 0x00000100 + c * 0x00010000 + d * 0x01000000
			index = index + 4
		end
		
		self:Block (self.Buffer)
		bufferIndex = 1
	end
	while index <= #data - 3 do
		local a, b, c, d = string_byte (data, index, index + 3)
		self.Buffer [bufferIndex] = a + b * 0x00000100 + c * 0x00010000 + d * 0x01000000
		bufferIndex = bufferIndex + 1
		index = index + 4
	end
	
	if index <= #data then
		local a, b, c = string_byte (data, index, index + 2)
		self.Buffer [bufferIndex] = a + (b or 0) * 0x00000100 + (c or 0) * 0x00010000
	end
	
	self.Length = self.Length + #data
	return self
end

function self:Finish ()
	local bufferIndex = math_floor (self.Length / 4) % blockSize + 1
	local bytesFilled = self.Length % 4
	if bytesFilled == 0 then
		self.Buffer [bufferIndex] = 0x00000080
	elseif bytesFilled == 1 then
		self.Buffer [bufferIndex] = self.Buffer [bufferIndex] + 0x00008000
	elseif bytesFilled == 2 then
		self.Buffer [bufferIndex] = self.Buffer [bufferIndex] + 0x00800000
	elseif bytesFilled == 3 then
		self.Buffer [bufferIndex] = self.Buffer [bufferIndex] + 0x80000000
	end
	bufferIndex = bufferIndex + 1
	for i = bufferIndex, blockSize do
		self.Buffer [i] = 0
	end
	
	if blockSize - bufferIndex + 1 < 2 then
		self:Block (self.Buffer)
		bufferIndex = 1
		
		for i = 1, blockSize do
			self.Buffer [i] = 0
		end
	end
	
	self.Buffer [blockSize - 1] = (self.Length * 8) % 4294967296
	self.Buffer [blockSize]     = math_floor ((self.Length * 8) / 4294967296)
	self:Block (self.Buffer)
	
	return string_format ("%08x%08x%08x%08x", bit_bswap (self.A) % 4294967296, bit_bswap (self.B) % 4294967296, bit_bswap (self.C) % 4294967296, bit_bswap (self.D) % 4294967296)
end
local K =
{
	0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
	0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
	0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
	0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
	0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
	0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
	0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
	0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
	0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
	0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
	0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
	0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
	0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
	0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
	0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
	0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391
}
local s =
{
	7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,
	5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,
	4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,
	6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21
}
local g =
{
	1, 2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, 16,
	2, 7, 12,  1,  6, 11, 16,  5, 10, 15,  4,  9, 14,  3,  8, 13,
	6, 9, 12, 15,  2,  5,  8, 11, 14,  1,  4,  7, 10, 13, 16,  3,
	1, 8, 15,  6, 13,  4, 11,  2,  9, 16,  7, 14,  5, 12,  3, 10
}
function self:Block (block)
	local M = block
	local a, b, c, d = self.A, self.B, self.C, self.D
	for i = 1, 16 do
		local F = bit_bor (bit_band (b, c), bit_band (bit_bnot (b), d))
		F = F + a + K [i] + M [g [i]]
		a, b, c, d = d, b + bit_rol (F, s [i]), b, c
	end
	for i = 17, 32 do
		local F = bit_bor (bit_band (d, b), bit_band (bit_bnot (d), c))
		F = F + a + K [i] + M [g [i]]
		a, b, c, d = d, b + bit_rol (F, s [i]), b, c
	end
	for i = 33, 48 do
		local F = bit_bxor (b, c, d)
		F = F + a + K [i] + M [g [i]]
		a, b, c, d = d, b + bit_rol (F, s [i]), b, c
	end
	for i = 49, 64 do
		local F = bit_bxor (c, bit_bor (b, bit_bnot (d)))
		F = F + a + K [i] + M [g [i]]
		a, b, c, d = d, b + bit_rol (F, s [i]), b, c
	end
	
	self.A, self.B, self.C, self.D = bit_tobit (self.A + a), bit_tobit (self.B + b), bit_tobit (self.C + c), bit_tobit (self.D + d)
end




local GarrysMod = SysTime
local Clock = GarrysMod


local Base64 = {}

local math_floor    = math.floor
local string_byte   = string.byte
local string_char   = string.char
local string_gmatch = string.gmatch
local string_sub    = string.sub
local table_concat  = table.concat

local characterSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

local equals = string_byte ("=")
local characterValues = {}
local valueCharacters = {}
for i = 1, #characterSet do
	characterValues [string_byte (characterSet, i)] = i - 1
	valueCharacters [i - 1] = string_byte (characterSet, i)
end
characterValues [string_byte ("=")] = 0

function Base64.Decode (s)
	local t = {}
	local a, b, c, d
	for abcd in string_gmatch (s, "[A-Za-z0-9%+/][A-Za-z0-9%+/][A-Za-z0-9%+/=][A-Za-z0-9%+/=]") do
		a, b, c, d = string_byte (abcd, 1, 4)
		local v0, v1, v2, v3 = characterValues [a], characterValues [b], characterValues [c], characterValues [d]
		local c0 =  v0 *  4 + math_floor (v1 * (1 / 16))
		local c1 = (v1 * 16 + math_floor (v2 * (1 /  4))) % 256
		local c2 = (v2 * 64 + v3) % 256
		t [#t + 1] = string_char (c0, c1, c2)
	end
	
	if d == equals then
		t [#t] = string_sub (t [#t], 1, c == equals and 1 or 2)
	end
	
	return table_concat (t)
end

function Base64.Encode (s)
	local t = {}
	
	for i = 3, #s, 3 do
		local c0, c1, c2 = string_byte (s, i - 2, i)
		local v0 = math_floor (c0 * (1 / 4))
		local v1 = (c0 * 16 + math_floor (c1 * (1 / 16))) % 64
		local v2 = (c1 *  4 + math_floor (c2 * (1 / 64))) % 64
		local v3 = c2 % 64
		t [#t + 1] = string_char (valueCharacters [v0], valueCharacters [v1], valueCharacters [v2], valueCharacters [v3])
	end
	
	if #s % 3 == 1 then
		local c0 = string_byte (s, #s)
		local v0 = math_floor (c0 * (1 / 4))
		local v1 = (c0 * 16) % 64
		t [#t + 1] = string_char (valueCharacters [v0], valueCharacters [v1], equals, equals)
	elseif #s % 3 == 2 then
		local c0, c1 = string_byte (s, #s - 1, #s)
		local v0 = math_floor (c0 * (1 / 4))
		local v1 = (c0 * 16 + math_floor (c1 * (1 / 16))) % 64
		local v2 = (c1 * 4) % 64
		t [#t + 1] = string_char (valueCharacters [v0], valueCharacters [v1], valueCharacters [v2], equals)
	end
	
	return table_concat (t)
end

local Base64 = Base64

local String = {}

local string_char   = string.char
local string_format = string.format
local string_gmatch = string.gmatch
local string_gsub   = string.gsub
local table_concat  = table.concat

local hexMap = {}
for i = 0, 255 do
	hexMap [string_format ("%02x", i)] = string_char (i)
	hexMap [string_format ("%02X", i)] = string_char (i)
end

function String.FromHex (data)
	local chars = {}
	for hex in string_gmatch (data, "[0-9a-fA-F][0-9a-fA-F]") do
		chars [#chars + 1] = hexMap [hex]
	end
	
	return table_concat (chars)
end

local hexMap = {}
for i = 0, 255 do hexMap [string_char (i)] = string_format ("%02x", i) end
function String.ToHex (str)
	return string_gsub (str, ".", hexMap)
end

local String = String


local UInt24 = {}

local bit_band   = bit.band
local math_floor = math.floor
local math_log   = math.log
local math_max   = math.max

UInt24.Zero               = 0x00000000
UInt24.Minimum            = 0x00000000
UInt24.Maximum            = 0x00FFFFFF
UInt24.MostSignificantBit = 0x00800000
UInt24.BitCount           = 24
function UInt24.Add (a, b)
	local c = a + b
	return bit_band (c, 0x00FFFFFF), math_floor (c / 0x01000000)
end
function UInt24.AddWithCarry (a, b, cf)
	local c = a + b + cf
	return bit_band (c, 0x00FFFFFF), math_floor (c / 0x01000000)
end
function UInt24.Subtract (a, b)
	local c = a - b
	return bit_band (c, 0x00FFFFFF), -math_floor (c / 0x01000000)
end
function UInt24.SubtractWithBorrow (a, b, cf)
	local c = a - b - cf
	return bit_band (c, 0x00FFFFFF), -math_floor (c / 0x01000000)
end
function UInt24.Multiply (a, b)
	local c = a * b
	return bit_band (c, 0x00FFFFFF), math_floor (c / 0x01000000)
end

function UInt24.MultiplyAdd1 (a, b, c)
	local c = a * b + c
	return bit_band (c, 0x00FFFFFF), math_floor (c / 0x01000000)
end
UInt24.MultiplyAdd = UInt24.MultiplyAdd1

function UInt24.MultiplyAdd2 (a, b, c, d)
	local c = a * b + c + d
	return bit_band (c, 0x00FFFFFF), math_floor (c / 0x01000000)
end

function UInt24.Divide (low, high, divisor)
	local a = low + 0x01000000 * high
	return math_floor (a / divisor), a % divisor
end

local k = math_log (2)
function UInt24.CountLeadingZeros (x)
	return 24 - math_max (0, math_floor (1 + math_log(x) / k))
end

UInt24.add = UInt24.Add
UInt24.adc = UInt24.AddWithCarry
UInt24.sub = UInt24.Subtract
UInt24.sbb = UInt24.SubtractWithBorrow
UInt24.mul = UInt24.Multiply
UInt24.div = UInt24.Divide
UInt24.clz = UInt24.CountLeadingZeros

local UInt24 = UInt24



local self = {}
local BigInteger = OOP.Class (self)

local tonumber      = tonumber

local bit_band      = bit.band
local bit_bnot      = bit.bnot
local bit_bor       = bit.bor
local bit_bxor      = bit.bxor
local bit_lshift    = bit.lshift
local bit_rshift    = bit.rshift
local math_abs      = math.abs
local math_floor    = math.floor
local math_log      = math.log
local math_min      = math.min
local math_max      = math.max
local string_byte   = string.byte
local string_char   = string.char
local string_format = string.format
local string_rep    = string.rep
local string_sub    = string.sub
local table_concat  = table.concat

local UInt24_Zero               = UInt24.Zero
local UInt24_Maximum            = UInt24.Maximum
local UInt24_MostSignificantBit = UInt24.MostSignificantBit
local UInt24_BitCount           = UInt24.BitCount

local UInt24_Add                = UInt24.Add
local UInt24_AddWithCarry       = UInt24.AddWithCarry
local UInt24_Divide             = UInt24.Divide
local UInt24_Multiply           = UInt24.Multiply
local UInt24_MultiplyAdd2       = UInt24.MultiplyAdd2
local UInt24_Subtract           = UInt24.Subtract
local UInt24_SubtractWithBorrow = UInt24.SubtractWithBorrow
local UInt24_CountLeadingZeros  = UInt24.CountLeadingZeros

local Sign_Negative = UInt24_Maximum
local Sign_Positive = UInt24_Zero

function BigInteger.FromBlob (data)
	local n = BigInteger ()
	n [1] = nil
	for i = #data - 2, 1, -3 do
		local c0, c1, c2 = string_byte (data, i, i + 2)
		n [#n + 1] = c0 * 0x00010000 + c1 * 0x00000100 + c2
	end
	if #data % 3 ~= 0 then
		local c = 0
		for i = 1, #data % 3 do
			c = c * 0x0100
			c = c + string_byte (data, i)
		end
		n [#n + 1] = c
	end
	n [#n + 1] = Sign_Positive
	n:Normalize ()
	
	return n
end

function BigInteger.FromDecimal (str)
	local n = BigInteger ()
	local sign     = string_sub (str, 1, 1)
	local negative = string_sub (str, 1, 1) == "-"
	local signLength = (sign == "-" or sign == "+") and 1 or 0
	local d = {}
	for i = #str - 7, 1 + signLength, -8 do
		d [#d + 1] = tonumber (string_sub (str, i, i + 7))
	end
	
	if (#str - signLength) % 8 ~= 0 then
		d [#d + 1] = tonumber (string_sub (str, 1 + signLength, signLength + (#str - signLength) % 8))
	end
	for i = #d, 1, -1 do
		if d [i] ~= 0 then break end
		
		d [i] = nil
	end
	n [1] = nil
	repeat
		local remainder = 0
		for i = #d, 1, -1 do
			local a = d [i] + remainder * 100000000
			d [i], remainder = math_floor (a / 0x01000000), bit_band (a, 0x00FFFFFF)
		end
		
		n [#n + 1] = remainder
		if d [#d] == 0 then
			d [#d] = nil
		end
	until #d == 0
	n [#n + 1] = Sign_Positive
	n:Normalize ()
	
	if negative then
		n = n:Negate (n)
	end
	
	return n
end

function BigInteger.FromHex (str)
	local n = BigInteger ()
	
	n [1] = nil
	for i = #str - 5, 1, -6 do
		n [#n + 1] = tonumber (string_sub (str, i, i + 5), 16)
	end
	if #str % 6 ~= 0 then
		n [#n + 1] = tonumber (string_sub (str, 1, #str % 6), 16)
	end
	n [#n + 1] = Sign_Positive
	n:Normalize ()
	
	return n
end

function BigInteger.FromUInt8 (x)
	return BigInteger.FromInt8 (x)
end

function BigInteger.FromUInt16 (x)
	return BigInteger.FromInt16 (x)
end

function BigInteger.FromUInt32 (x)
	return BigInteger.FromInt32 (x)
end

function BigInteger.FromUInt64 (x)
	return BigInteger.FromInt64 (x)
end

function BigInteger.FromInt8 (x)
	return BigInteger.FromInt16 (x)
end

function BigInteger.FromInt16 (x)
	local n = BigInteger ()
	n [1] = x % 0x01000000
	n [2] = x >= 0 and Sign_Positive or Sign_Negative
	n:Normalize ()
	return n
end

function BigInteger.FromInt32 (x)
	local n = BigInteger ()
	n [1] = x % 0x01000000
	n [2] = math_floor (x / 0x01000000) % 0x01000000
	n [3] = x >= 0 and Sign_Positive or Sign_Negative
	n:Normalize ()
	return n
end

function BigInteger.FromInt64 (x)
	local n = BigInteger ()
	n [1] = x % 0x01000000
	n [2] = math_floor (x / 0x01000000) % 0x01000000
	n [3] = math_floor (x / 0x01000000 / 0x01000000) % 0x01000000
	n [4] = x >= 0 and Sign_Positive or Sign_Negative
	n:Normalize ()
	return n
end

function BigInteger.FromDouble (x)
	local n = BigInteger ()
	
	if x == math.huge or x == -math.huge or x ~= x then
		return n 
	else
		n [1] = nil
		x = math_floor (x)
		while x ~= 0 and x ~= -1 do
			n [#n + 1] = x % 0x01000000
			x = math_floor (x / 0x01000000)
		end
		n [#n + 1] = x >= 0 and Sign_Positive or Sign_Negative
		n:Normalize ()
		
		return n
	end
end

function self:ctor ()
	self [1] = Sign_Positive
end

function self:GetBitCount ()
	local leadingBitCount = 1 + math_floor (math_log (self [#self - 1]) / math_log (2))
	leadingBitCount = math_max (0, leadingBitCount)
	local bitCount = (#self - 2) * UInt24_BitCount
	return bitCount + leadingBitCount
end

function self:IsPositive ()
	return self [#self] == Sign_Positive and #self > 1
end

function self:IsNegative ()
	return self [#self] == Sign_Negative
end

function self:IsZero ()
	return #self == 1 and self [1] == Sign_Positive
end
function self:Compare (b)
	local a = self
	if a [#a] ~= b [#b] then return a [#a] == Sign_Negative and -1 or 1 end
	
	if #a == #b then
		for i = #a - 1, 1, -1 do
			if a [i] < b [i] then
				return a [#a] == Sign_Positive and -1 or  1
			elseif a [i] > b [i] then
				return a [#a] == Sign_Positive and  1 or -1
			end
		end
		
		return 0
	elseif #a < #b then
		return a [#a] == Sign_Positive and -1 or  1
	else
		return a [#a] == Sign_Positive and  1 or -1
	end
end

function self:Equals (b)
	local a = self
	if #a ~= #b then return false end
	
	for i = 1, #a do
		if a [i] ~= b [i] then return false end
	end
	
	return true
end

function self:IsLessThan           (b) return self:Compare (b) == -1 end
function self:IsLessThanOrEqual    (b) return self:Compare (b) ~=  1 end
function self:IsGreaterThan        (b) return self:Compare (b) ==  1 end
function self:IsGreaterThanOrEqual (b) return self:Compare (b) ~= -1 end
function self:IsEven () return self [1] % 2 == 0 end
function self:IsOdd  () return self [1] % 2 == 1 end
function self:Negate (b, out)
	out = self:Not (out)
	local cf = 1
	for i = 1, #out do
		if cf == 0 then break end
		out [i], cf = UInt24_Add (out [i], cf)
	end
	if out [#out] == 1 then
		out [#out + 1] = Sign_Positive
	end
	
	return out
end

function self:Add (b, out)
	local out = out or BigInteger ()
	local a = self
	local cf = 0
	for i = 1, math_min(#a, #b) do
		out [i], cf = UInt24_AddWithCarry (a [i], b [i], cf)
	end
	for i = #a + 1, #b do out [i], cf = UInt24_AddWithCarry (a [#a], b [i], cf) end
	for i = #b + 1, #a do out [i], cf = UInt24_AddWithCarry (a [i], b [#b], cf) end
	out:Truncate (math_max (#a, #b))
	if out [#out] ~= Sign_Positive and
	   out [#out] ~= Sign_Negative then
		out [#out + 1] = cf == 0 and Sign_Positive or Sign_Negative
	end
	out:Normalize ()
	
	return out
end

function self:Subtract (b, out)
	local out = out or BigInteger ()
	local a = self
	
	local cf = 0
	for i = 1, math_min (#a, #b) do
		out [i], cf = UInt24_SubtractWithBorrow (a [i], b [i], cf)
	end
	for i = #a + 1, #b do out [i], cf = UInt24_SubtractWithBorrow (a [#a], b [i], cf) end
	for i = #b + 1, #a do out [i], cf = UInt24_SubtractWithBorrow (a [i], b [#b], cf) end
	out:Truncate (math_max (#a, #b))
	if out [#out] ~= Sign_Positive and
	   out [#out] ~= Sign_Negative then
		out [#out + 1] = cf == 0 and Sign_Negative or Sign_Positive
	end
	out:Normalize ()
	
	return out
end

function self:Clone (out)
	local out = out or BigInteger ()
	
	for i = 1, #self do
		out [i] = self [i]
	end
	
	out:Truncate (#self)
	
	return out
end

function self:Multiply (b, out)
	local out = out or BigInteger ()
	local a = self
	out:TruncateAndZero (#a + #b - 1)
	for i = 1, #a do
		local high = 0
		for j = 1, #b do
			out [i + j - 1], high = UInt24_MultiplyAdd2 (a [i], b [j], out [i + j - 1], high)
		end
		for j = i + #b, #a + #b - 1 do
			if high == 0 then break end
			out [j], high = UInt24_Add (out [j], high)
		end
	end
	out:Truncate (math_max (1, #a - 1 + #b - 1))
	out [#out + 1] = (a:IsZero() or b:IsZero()) and Sign_Positive or bit_bxor(a [#a], b [#b])
	out:Normalize ()
	
	return out
end

function self:Square (out)
	local out = out or BigInteger ()
	local a = self
	out:TruncateAndZero (#a * 2 - 1)
	for i = 1, #a do
		local high = 0
		for j = 1, i - 1 do
			out [i + j - 1], high = UInt24_MultiplyAdd2 (a [i], a [j], out [i + j - 1], high)
		end
		for j = i * 2 - 1, #a * 2 - 1 do
			if high == 0 then break end
			out [j], high = UInt24_Add (out [j], high)
		end
	end
	local carry = 0
	for i = 1, #a * 2 - 1 do
		out [i], carry = UInt24_AddWithCarry (out [i], out [i], carry)
	end
	local high = 0
	for i = 1, #a - 1 do
		out [i + i - 1], high = UInt24_MultiplyAdd2 (a [i], a [i], out [i + i - 1], high)
		out [i + i], high = UInt24_Add (out [i + i], high)
	end
	out:Truncate (math_max (1, #a * 2 - 2))
	out [#out + 1] = Sign_Positive
	out:Normalize ()
	
	return out
end

function self:Divide (b, quotient, remainder)
	if #b <= 2 then
		local quotient, remainder = self:DivideInt24 (b:IsNegative () and -(UInt24_Maximum - b [1] + 1) or b [1], quotient)
		return quotient, BigInteger.FromInt32 (remainder)
	end
	local quotient  = quotient or BigInteger ()
	local remainder = self:IsNegative () and self:Negate (remainder) or self:Clone (remainder)
	local a = self
	
	if b:IsZero () then
		quotient:TruncateAndZero (1)
		return quotient, remainder
	end
	
	local negative = a:IsNegative () ~= b:IsNegative ()
	if a:IsNegative () then a = a:Negate () end
	if b:IsNegative () then b = b:Negate () end
	
	quotient:TruncateAndZero (math_max (1, #a - #b + 2))
	local additionalBitCount = UInt24_CountLeadingZeros (b [#b - 1]) + 1
	local d = b [#b - 1] * bit_lshift (1, additionalBitCount) + bit_rshift (b [#b - 2], UInt24_BitCount - additionalBitCount)
	
	for i = #a - #b + 1, 1, -1 do
		local r1 = remainder [i + #b - 1] or 0
		local r0 = remainder [i + #b - 2]
		local r = (r1 * (UInt24_Maximum + 1) + r0) * bit_lshift (1, additionalBitCount) + bit_rshift (remainder [i + #b - 3], UInt24_BitCount - additionalBitCount)
		local q = math_floor (r / d)
		
		local p0, p1 = 0, 0
		local borrow = 0
		for j = 1, #b - 1 do
			p0, p1 = UInt24_MultiplyAdd2 (b [j], q, p1, borrow)
			remainder [i + j - 1], borrow = UInt24_Subtract (remainder [i + j - 1], p0)
		end
		
		remainder [i + #b - 1], borrow = UInt24_SubtractWithBorrow (remainder [i + #b - 1] or 0, p1, borrow)
		
		if borrow > 0 then
			q = q - 1
			
			local carry = 0
			for j = 1, #b - 1 do
				remainder [i + j - 1], carry = UInt24_AddWithCarry (remainder [i + j - 1], b [j], carry)
			end
			remainder [i + #b - 1] = UInt24_Add (remainder [i + #b - 1], carry)
		end
		
		quotient [i] = q
	end
	quotient:Normalize ()
	remainder:Normalize ()
	
	if negative then
		quotient = quotient:Negate (quotient)
	end
	
	return quotient, remainder
end

function self:DivideInt24 (b, out)
	local out = out or BigInteger ()
	local a = self
	
	local negative = a:IsNegative () ~= (b < 0)
	local b = math_abs (b)
	
	if a:IsNegative () then
		a = a:Negate ()
	end
	out:Truncate (#a)
	local remainder = 0
	for i = #a, 1, -1 do
		out [i], remainder = UInt24_Divide (a [i], remainder, b)
	end
	out:Normalize ()
	
	if negative then
		out = out:Negate (out)
	end
	
	return out, remainder
end

function self:Exponentiate (exponent)
	local out = BigInteger.FromUInt32 (1)
	local temp = BigInteger ()
	local exponentBitCount = exponent:GetBitCount ()
	
	local factor = self:Clone ()
	for i = 1, #exponent - 1 do
		local mask = 1
		for j = 1, math.min (UInt24_BitCount, exponentBitCount - (i - 1) * UInt24_BitCount) do
			if bit_band (exponent [i], mask) ~= 0 then
				out, temp = out:Multiply (factor, temp), out
			end
			
			mask = mask * 2
			factor, temp = factor:Square (temp), factor
		end
	end
	
	return out
end

function self:ExponentiateMod (exponent, m)
	if m:IsOdd () and #exponent >= 4 then return self:MontgomeryExponentiateMod (exponent, m) end
	
	local out = BigInteger.FromUInt32 (1)
	local product  = BigInteger ()
	local quotient = BigInteger ()
	
	local factor = self:Clone ()
	for i = 1, #exponent - 1 do
		local mask = 1
		for j = 1, UInt24_BitCount do
			if bit_band (exponent [i], mask) ~= 0 then
				product = out:Multiply (factor, product)
				out = product:Mod (m, out, quotient)
			end
			
			mask = mask * 2
			product = factor:Square (product)
			factor = product:Mod (m, factor, quotient)
		end
	end
	
	return out
end

function self:Mod (b, remainder, quotient)
	local quotient, remainder = self:Divide (b, quotient, remainder)
	return remainder, quotient
end
function self:And (b, out)
	local out = out or BigInteger ()
	local a = self
	if #a < #b then a, b = b, a end
	for i = 1, #b do
		out [i] = bit_band (a [i], b [i])
	end
	
	if b:IsNegative () then
		for i = #b + 1, #a do
			out [i] = a [i]
		end
		out:Truncate (#a)
	else
		out:Truncate (#b)
		out:Normalize ()
	end
	
	return out
end

function self:Or (b, out)
	local out = out or BigInteger ()
	local a = self
	if #a < #b then a, b = b, a end
	for i = 1, #b do
		out [i] = bit_bor (a [i], b [i])
	end
	
	if b:IsNegative () then
		out:Truncate (#b)
		out:Normalize ()
	else
		for i = #b + 1, #a do
			out [i] = a [i]
		end
		out:Truncate (#a)
	end
	
	return out
end

function self:Xor (b, out)
	local out = out or BigInteger ()
	local a = self
	if #a < #b then a, b = b, a end
	for i = 1, #b do
		out [i] = bit_bxor (a [i], b [i])
	end
	
	if b:IsNegative () then
		for i = #b + 1, #a do
			out [i] = bit_bxor (a [i], UInt24_Maximum)
		end
		out:Truncate (#a)
	else
		for i = #b + 1, #a do
			out [i] = a [i]
		end
		out:Truncate (#a)
	end
	
	return out
end

function self:Not (out)
	local out = out or BigInteger ()
	
	for i = 1, #self do
		out [i] = bit_bxor (self [i], UInt24_Maximum)
	end
	
	out:Truncate (#self)
	
	return out
end
function self:ModularInverse (m)
	local a, b = m, self
	local previousR, r = a:Clone (), b:Clone ()
	local previousT, t = BigInteger (), BigInteger.FromDouble (1)
	local temp = BigInteger ()
	local q = BigInteger ()
	while not r:IsZero () do
		q, temp = previousR:Divide (r, q, temp)
		previousR, r, temp = r, temp, previousR
		temp = t:Multiply (q, temp)
		temp, q = previousT:Subtract (temp, q), temp
		previousT, t, temp = t, temp, previousT
	end
	if previousR:IsPositive () and (#previousR > 2 or previousR [1] > 1) then return nil end
	return previousT:IsNegative () and previousT:Add (m, temp) or previousT
end

function self:Root (n)
	if self:IsNegative () then return false, nil end
	if not n:IsPositive () then return false, nil end
	if self:IsZero () then return true, self end
	if self:Equals (BigInteger.FromDouble (1)) then return true, self end
	if n:Equals (BigInteger.FromDouble (1)) then return true, self end
	
	local one = BigInteger.FromDouble (1)
	local two = BigInteger.FromDouble (2)
	local temp1 = BigInteger ()
	local temp2 = BigInteger ()
	local lowerBound = one:Clone ()
	local upperBound = two:Exponentiate (BigInteger.FromDouble (self:GetBitCount ()) / n + 1)
	local mid = BigInteger ()
	while not lowerBound:Equals (upperBound) do
		temp1 = lowerBound:Add (upperBound, temp1)
		temp1 = temp1:Add (one, temp1)
		mid = temp1:Divide (two, mid, temp2)
		
		temp1 = mid:Exponentiate (n, temp1)
		local cmp = temp1:Compare (self)
		if cmp == 0 then
			return true, mid
		elseif cmp == 1 then
			upperBound = mid:Subtract (one)
		elseif cmp == -1 then
			lowerBound = mid:Clone (lowerBound)
		end
	end
	
	temp1 = lowerBound:Exponentiate (n, temp1)
	return temp1:Equals (self), lowerBound
end
function self:ToBlob ()
	local t = {}
	local x = self [#self - 1]
	local c0 = bit_rshift (x, 16)
	local c1 = bit_band (bit_rshift (x, 8), 0xFF)
	local c2 = bit_band (x, 0xFF)
	
	if c0 > 0 then
		t [#t + 1] = string_char (c0, c1, c2)
	elseif c1 > 0 then
		t [#t + 1] = string_char (c1, c2)
	else
		t [#t + 1] = string_char (c2)
	end
	for i = #self - 2, 1, -1 do
		local x = self [i]
		local c0 = bit_rshift (x, 16)
		local c1 = bit_band (bit_rshift (x, 8), 0xFF)
		local c2 = bit_band (x, 0xFF)
		
		t [#t + 1] = string_char (c0, c1, c2)
	end
	
	return table_concat (t)
end

function self:ToDecimal ()
	local negative = self:IsNegative ()
	local n = negative and self:Negate () or self:Clone ()
	local t = {}
	repeat
		n, t [#t + 1] = n:DivideInt24 (10000000, n)
	until n:IsZero ()
	for i = 1, #t / 2 do
		t [i], t [#t - i + 1] = t [#t - i + 1], t [i]
	end
	t [1] = (negative and "-" or "") .. tonumber (t [1])
	for i = 2, #t do
		t [i] = string_format ("%07d", t [i])
	end
	
	return table_concat (t)
end

function self:ToHex (digitCount)
	if #self == 1 then return string_rep (self [#self] == UInt24_Zero and "0" or "f", digitCount or 2) end
	
	local t = {}
	if digitCount then
		digitCount = math_max (0, digitCount - 6 * (#self - 2))
	else
		digitCount = 2
	end
	if self:IsNegative () and digitCount > 6 then
		t [#t + 1] = string_rep ("f", digitCount - 6)
		digitCount = 6
	end
	
	t [#t + 1] = string_format ("%0" .. digitCount .. "x", self [#self - 1])
	for i = #self - 2, 1, -1 do
		t [#t + 1] = string_format ("%06x", self [i])
	end
	
	return table_concat (t)
end

function self:ToUInt32 ()
	return self [1] + bit_lshift (bit_band (self [2] or 0, 0xFF), UInt24_BitCount)
end
function self:Normalize ()
	local sign = self [#self]
	for i = #self - 1, 1, -1 do
		if self [i] ~= sign then break end
		
		self [i + 1] = nil
	end
end

function self:Truncate (elementCount)
	for i = #self, elementCount + 1, -1 do
		self [i] = nil
	end
end

local BigInteger_Truncate = self.Truncate
function self:TruncateAndZero (elementCount)
	for i = 1, elementCount do
		self [i] = 0
	end
	
	BigInteger_Truncate (self, elementCount)
end

function self:MontgomeryReduce (m′, m, out, temp)
	out = out or BigInteger ()
	out:TruncateAndZero (#m + #m - 1)
	for i = 1, #self do out [i] = self [i] end
	for i = 1, #m - 1 do
		local u = UInt24_Multiply (out [i], m′ [1])
		
		local high = 0
		for j = 1, #m - 1 do
			out [i + j - 1], high = UInt24_MultiplyAdd2 (u, m [j], high, out [i + j - 1])
		end
		for j = i + #m - 1, #m + #m - 1 do
			if high == 0 then break end
			out [j], high = UInt24_Add (out [j], high)
		end
	end
	local shift = #m - 1
	for i = 1, #out - shift do
		out [i] = out [i + shift]
	end
	for i = #out, #out - shift + 1, -1 do
		out [i] = nil
	end
	out:Normalize ()
	if out:IsGreaterThanOrEqual (m) then
		return out:Subtract (m, temp), out
	else
		return out, temp
	end
end

function self:MontgomeryExponentiateMod (exponent, m)
	local temp1 = BigInteger.FromDouble (0x01000000)
	local temp2 = BigInteger ()
	for i = 1, #m - 1 do
		temp2 [i] = 0
	end
	temp2 [#m] = 0x00000001
	temp2 [#m + 1] = Sign_Positive
	local m′ = m:ModularInverse (temp1)
	m′ [1] = -m′ [1] + 0x01000000
	local out = temp2:Mod (m, BigInteger (), temp1)
	local factor = self:Multiply (out, temp1):Mod (m, BigInteger (), temp2)
	for i = 1, #exponent - 1 do
		local mask = 1
		for j = 1, UInt24_BitCount do
			if bit_band (exponent [i], mask) ~= 0 then
				temp1 = out:Multiply (factor, temp1)
				out, temp2 = temp1:MontgomeryReduce (m′, m, out, temp2)
			end
			
			mask = mask * 2
			temp1 = factor:Square (temp1)
			factor, temp2 = temp1:MontgomeryReduce (m′, m, factor, temp2)
		end
	end
	
	return out:MontgomeryReduce (m′, m, temp1, temp2)
end

function self:__unm ()
	return self:Negate ()
end

function self:__add (b)
	if type (b) == "number" then b = BigInteger.FromDouble (b) end
	return self:Add (b)
end

function self:__sub (b)
	if type (b) == "number" then b = BigInteger.FromDouble (b) end
	return self:Subtract (b)
end

function self:__mul (b)
	if type (b) == "number" then b = BigInteger.FromDouble (b) end
	return self:Multiply (b)
end

function self:__div (b)
	if type (b) == "number" then b = BigInteger.FromDouble (b) end
	return self:Divide (b)
end

function self:__mod (b)
	if type (b) == "number" then b = BigInteger.FromDouble (b) end
	return self:Mod (b)
end

function self:__pow (b)
	if type (b) == "number" then b = BigInteger.FromDouble (b) end
	return self:Exponentiate (b)
end

function self:__eq (b)
	if type (b) == "number" then b = BigInteger.FromDouble (b) end
	return self:Equals (b)
end

function self:__lt (b)
	if type (b) == "number" then b = BigInteger.FromDouble (b) end
	return self:IsLessThan (b)
end

function self:__le (b)
	if type (b) == "number" then b = BigInteger.FromDouble (b) end
	return self:IsLessThanOrEqual (b)
end

function self:__tostring ()
	return self:ToDecimal ()
end

local BigInteger = BigInteger



local BitConverter = {}

local bit_band   = bit.band
local bit_lshift = bit.lshift
local bit_rshift = bit.rshift
local math_floor = math.floor
local math_frexp = math.frexp
local math_ldexp = math.ldexp
local math_huge  = math.huge
function BitConverter.UInt8ToUInt8s (n)
	return n
end

function BitConverter.UInt16ToUInt8s (n)
	return             n        % 256,
	       math_floor (n / 256) % 256
end

function BitConverter.UInt32ToUInt8s (n)
	return             n             % 256,
	       math_floor (n /      256) % 256,
	       math_floor (n /    65536) % 256,
	       math_floor (n / 16777216) % 256
end

function BitConverter.UInt64ToUInt8s (n)
	return             n                      % 256,
	       math_floor (n /               256) % 256,
	       math_floor (n /             65536) % 256,
	       math_floor (n /          16777216) % 256,
	       math_floor (n /        4294967296) % 256,
	       math_floor (n /     1099511627776) % 256,
	       math_floor (n /   281474976710656) % 256,
	       math_floor (n / 72057594037927936) % 256
end

function BitConverter.UInt8sToUInt8(uint80)
	return uint80
end

function BitConverter.UInt8sToUInt16 (uint80, uint81)
	return uint80 +
	       uint81 * 256
end

function BitConverter.UInt8sToUInt32 (uint80, uint81, uint82, uint83)
	return uint80 +
	       uint81 * 256 +
	       uint82 * 65536 +
	       uint83 * 16777216
end

function BitConverter.UInt8sToUInt64 (uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87)
	return uint80 +
	       uint81 * 256 +
	       uint82 * 65536 +
	       uint83 * 16777216 +
	       uint84 * 4294967296 +
	       uint85 * 1099511627776 +
	       uint86 * 281474976710656 +
	       uint87 * 72057594037927936
end

function BitConverter.Int8ToUInt8s (n)
	if n < 0 then n = n + 256 end
	return BitConverter.UInt8ToUInt8s (n)
end

function BitConverter.Int16ToUInt8s (n)
	if n < 0 then n = n + 65536 end
	return BitConverter.UInt16ToUInt8s (n)
end

function BitConverter.Int32ToUInt8s (n)
	if n < 0 then n = n + 4294967296 end
	return BitConverter.UInt32ToUInt8s (n)
end

function BitConverter.Int64ToUInt8s (n)
	local uint80, uint81, uint82, uint83 = BitConverter.UInt32ToUInt8s (n % 4294967296)
	local uint84, uint85, uint86, uint87 = BitConverter.Int32ToUInt8s (math_floor (n / 4294967296))
	return uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87
end

function BitConverter.UInt8sToInt8 (uint80)
	local n = BitConverter.UInt8sToUInt8 (uint80)
	if n >= 128 then n = n - 256 end
	return n
end

function BitConverter.UInt8sToInt16 (uint80, uint81)
	local n = BitConverter.UInt8sToUInt16 (uint80, uint81)
	if n >= 32768 then n = n - 65536 end
	return n
end

function BitConverter.UInt8sToInt32 (uint80, uint81, uint82, uint83)
	local n = BitConverter.UInt8sToUInt32 (uint80, uint81, uint82, uint83)
	if n >= 2147483648 then n = n - 4294967296 end
	return n
end

function BitConverter.UInt8sToInt64 (uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87)
	local low  = BitConverter.UInt8sToUInt32 (uint80, uint81, uint82, uint83)
	local high = BitConverter.UInt8sToInt32 (uint84, uint85, uint86, uint87)
	return low + high * 4294967296
end
function BitConverter.FloatToUInt32 (f)
	local n = 0
	if f < 0 or 1 / f < 0 then
		n = n + 0x80000000
		f = -f
	end
	
	local mantissa = 0
	local biasedExponent = 0
	
	if f == math_huge then
		biasedExponent = 0xFF
	elseif f ~= f then
		biasedExponent = 0xFF
		mantissa = 1
	elseif f == 0 then
		biasedExponent = 0x00
	else
		mantissa, biasedExponent = math_frexp (f)
		biasedExponent = biasedExponent + 126
		
		if biasedExponent <= 0 then
			mantissa = math_floor (mantissa * 2 ^ (23 + biasedExponent) + 0.5)
			biasedExponent = 0
		else
			mantissa = math_floor ((mantissa * 2 - 1) * 2 ^ 23 + 0.5)
		end
	end
	
	n = n + bit_lshift (bit_band (biasedExponent, 0xFF), 23)
	n = n + bit_band (mantissa, 0x007FFFFF)
	
	return n
end

function BitConverter.DoubleToUInt32s (f)
	local high = 0
	local low  = 0
	if f < 0 or 1 / f < 0 then
		high = high + 0x80000000
		f = -f
	end
	
	local mantissa = 0
	local biasedExponent = 0
	
	if f == math_huge then
		biasedExponent = 0x07FF
	elseif f ~= f then
		biasedExponent = 0x07FF
		mantissa = 1
	elseif f == 0 then
		biasedExponent = 0x00
	else
		mantissa, biasedExponent = math_frexp (f)
		biasedExponent = biasedExponent + 1022
		
		if biasedExponent <= 0 then
			mantissa = math_floor (mantissa * 2 ^ (52 + biasedExponent) + 0.5)
			biasedExponent = 0
		else
			mantissa = math_floor ((mantissa * 2 - 1) * 2 ^ 52 + 0.5)
		end
	end
	
	low = mantissa % 4294967296
	high = high + bit_lshift (bit_band (biasedExponent, 0x07FF), 20)
	high = high + bit_band (math_floor (mantissa / 4294967296), 0x000FFFFF)
	
	return low, high
end

function BitConverter.UInt32ToFloat (n)
	
	local negative = false
	
	if n >= 0x80000000 then
		negative = true
		n = n - 0x80000000
	end
	
	local biasedExponent = bit_rshift (bit_band (n, 0x7F800000), 23)
	local mantissa = bit_band (n, 0x007FFFFF) / (2 ^ 23)
	
	local f
	if biasedExponent == 0x00 then
		f = mantissa == 0 and 0 or math_ldexp (mantissa, -126)
	elseif biasedExponent == 0xFF then
		f = mantissa == 0 and math_huge or (math_huge - math_huge)
	else
		f = math_ldexp (1 + mantissa, biasedExponent - 127)
	end
	
	return negative and -f or f
end

function BitConverter.UInt32sToDouble (low, high)
	
	local negative = false
	
	if high >= 0x80000000 then
		negative = true
		high = high - 0x80000000
	end
	
	local biasedExponent = bit_rshift (bit_band (high, 0x7FF00000), 20)
	local mantissa = (bit_band (high, 0x000FFFFF) * 4294967296 + low) / 2 ^ 52
	
	local f
	if biasedExponent == 0x0000 then
		f = mantissa == 0 and 0 or math_ldexp (mantissa, -1022)
	elseif biasedExponent == 0x07FF then
		f = mantissa == 0 and math_huge or (math_huge - math_huge)
	else
		f = math_ldexp (1 + mantissa, biasedExponent - 1023)
	end
	
	return negative and -f or f
end

local BitConverter = BitConverter

local IO = {}
IO.Endianness = Enum (
	{
		LittleEndian = 0,
		BigEndian    = 1
	}
)

local self = {}
IO.IBaseStream = Interface (self, IDisposable)

function self:ctor ()
end

function self:dtor ()
	self:Close ()
end

function self:Close ()
	Error ("IBaseStream:Close : Not implemented.")
end

function self:GetPosition ()
	Error ("IBaseStream:GetPosition : Not implemented.")
end

function self:GetSize ()
	Error ("IBaseStream:GetSize : Not implemented.")
end

function self:IsEndOfStream ()
	return self:GetPosition () >= self:GetSize ()
end

function self:SeekAbsolute (seekPos)
	Error ("IBaseStream:SeekAbsolute : Not implemented.")
end

function self:SeekRelative (relativeSeekPos)
	self:SeekAbsolute (self:GetPosition () + relativeSeekPos)
end

local self = {}
IO.IInputStream = Interface (self, IO.IBaseStream)

function self:ctor ()
end

function self:Read (length)
	Error ("IInputStream:Read : Not implemented.")
end

function self:ToStreamReader ()
	return IO.BufferedStreamReader (self)
end

local self = {}
IO.IOutputStream = Interface (self, IO.IBaseStream)

function self:ctor ()
end

function self:Write (data, length)
	Error ("IOutputStream:Write : Not implemented.")
end

function self:ToStreamWriter ()
	return IO.BufferedStreamWriter (self)
end

local self = {}
IO.IStreamReader = Interface (self, IO.IInputStream)

function self:ctor ()
end
function self:ToStreamReader ()
	return self
end
function self:GetEndianness ()
	Error ("IStreamReader:GetEndianness : Not implemented.")
end

function self:SetEndianness (endianness)
	Error ("IStreamReader:SetEndianness : Not implemented.")
end

function self:UInt8    () Error ("IStreamReader:UInt8 : Not implemented.")    end
function self:UInt16   () Error ("IStreamReader:UInt16 : Not implemented.")   end
function self:UInt32   () Error ("IStreamReader:UInt32 : Not implemented.")   end
function self:UInt64   () Error ("IStreamReader:UInt64 : Not implemented.")   end

function self:Int8     () Error ("IStreamReader:Int8 : Not implemented.")     end
function self:Int16    () Error ("IStreamReader:Int16 : Not implemented.")    end
function self:Int32    () Error ("IStreamReader:Int32 : Not implemented.")    end
function self:Int64    () Error ("IStreamReader:Int64 : Not implemented.")    end

function self:UInt8LE  () Error ("IStreamReader:UInt8LE : Not implemented.")  end
function self:UInt16LE () Error ("IStreamReader:UInt16LE : Not implemented.") end
function self:UInt32LE () Error ("IStreamReader:UInt32LE : Not implemented.") end
function self:UInt64LE () Error ("IStreamReader:UInt64LE : Not implemented.") end

function self:Int8LE   () Error ("IStreamReader:Int8LE : Not implemented.")   end
function self:Int16LE  () Error ("IStreamReader:Int16LE : Not implemented.")  end
function self:Int32LE  () Error ("IStreamReader:Int32LE : Not implemented.")  end
function self:Int64LE  () Error ("IStreamReader:Int64LE : Not implemented.")  end

function self:UInt8BE  () Error ("IStreamReader:UInt8BE : Not implemented.")  end
function self:UInt16BE () Error ("IStreamReader:UInt16BE : Not implemented.") end
function self:UInt32BE () Error ("IStreamReader:UInt32BE : Not implemented.") end
function self:UInt64BE () Error ("IStreamReader:UInt64BE : Not implemented.") end

function self:Int8BE   () Error ("IStreamReader:Int8BE : Not implemented.")   end
function self:Int16BE  () Error ("IStreamReader:Int16BE : Not implemented.")  end
function self:Int32BE  () Error ("IStreamReader:Int32BE : Not implemented.")  end
function self:Int64BE  () Error ("IStreamReader:Int64BE : Not implemented.")  end

function self:Float    () Error ("IStreamReader:Float : Not implemented.")    end
function self:Double   () Error ("IStreamReader:Double : Not implemented.")   end

function self:FloatLE  () Error ("IStreamReader:FloatLE : Not implemented.")  end
function self:DoubleLE () Error ("IStreamReader:DoubleLE : Not implemented.") end

function self:FloatBE  () Error ("IStreamReader:FloatBE : Not implemented.")  end
function self:DoubleBE () Error ("IStreamReader:DoubleBE : Not implemented.") end

function self:Boolean  () Error ("IStreamReader:Boolean : Not implemented.")  end

function self:Bytes (length)
	Error ("IStreamReader:Bytes : Not implemented.")
end

function self:StringN8    () Error ("IStreamReader:StringN8 : Not implemented.")    end
function self:StringN16   () Error ("IStreamReader:StringN16 : Not implemented.")   end
function self:StringN32   () Error ("IStreamReader:StringN32 : Not implemented.")   end

function self:StringN8LE  () Error ("IStreamReader:StringN8LE : Not implemented.")  end
function self:StringN16LE () Error ("IStreamReader:StringN16LE : Not implemented.") end
function self:StringN32LE () Error ("IStreamReader:StringN32LE : Not implemented.") end

function self:StringN8BE  () Error ("IStreamReader:StringN8BE : Not implemented.")  end
function self:StringN16BE () Error ("IStreamReader:StringN16BE : Not implemented.") end
function self:StringN32BE () Error ("IStreamReader:StringN32BE : Not implemented.") end

function self:StringZ     () Error ("IStreamReader:StringZ : Not implemented.")     end

local self = {}
IO.IStreamWriter = Interface (self, IO.IOutputStream)

function self:ctor ()
end
function self:ToStreamWriter ()
	return self
end
function self:GetEndianness ()
	Error ("IStreamWriter:GetEndianness : Not implemented.")
end

function self:SetEndianness (endianness)
	Error ("IStreamWriter:SetEndianness : Not implemented.")
end

function self:UInt8    (n) Error ("IStreamWriter:UInt8 : Not implemented.")    end
function self:UInt16   (n) Error ("IStreamWriter:UInt16 : Not implemented.")   end
function self:UInt32   (n) Error ("IStreamWriter:UInt32 : Not implemented.")   end
function self:UInt64   (n) Error ("IStreamWriter:UInt64 : Not implemented.")   end

function self:Int8     (n) Error ("IStreamWriter:Int8 : Not implemented.")     end
function self:Int16    (n) Error ("IStreamWriter:Int16 : Not implemented.")    end
function self:Int32    (n) Error ("IStreamWriter:Int32 : Not implemented.")    end
function self:Int64    (n) Error ("IStreamWriter:Int64 : Not implemented.")    end

function self:UInt8LE  (n) Error ("IStreamWriter:UInt8LE : Not implemented.")  end
function self:UInt16LE (n) Error ("IStreamWriter:UInt16LE : Not implemented.") end
function self:UInt32LE (n) Error ("IStreamWriter:UInt32LE : Not implemented.") end
function self:UInt64LE (n) Error ("IStreamWriter:UInt64LE : Not implemented.") end

function self:Int8LE   (n) Error ("IStreamWriter:Int8LE : Not implemented.")   end
function self:Int16LE  (n) Error ("IStreamWriter:Int16LE : Not implemented.")  end
function self:Int32LE  (n) Error ("IStreamWriter:Int32LE : Not implemented.")  end
function self:Int64LE  (n) Error ("IStreamWriter:Int64LE : Not implemented.")  end

function self:UInt8BE  (n) Error ("IStreamWriter:UInt8BE : Not implemented.")  end
function self:UInt16BE (n) Error ("IStreamWriter:UInt16BE : Not implemented.") end
function self:UInt32BE (n) Error ("IStreamWriter:UInt32BE : Not implemented.") end
function self:UInt64BE (n) Error ("IStreamWriter:UInt64BE : Not implemented.") end

function self:Int8BE   (n) Error ("IStreamWriter:Int8BE : Not implemented.")   end
function self:Int16BE  (n) Error ("IStreamWriter:Int16BE : Not implemented.")  end
function self:Int32BE  (n) Error ("IStreamWriter:Int32BE : Not implemented.")  end
function self:Int64BE  (n) Error ("IStreamWriter:Int64BE : Not implemented.")  end

function self:Float    (f) Error ("IStreamWriter:Float : Not implemented.")    end
function self:Double   (f) Error ("IStreamWriter:Double : Not implemented.")   end

function self:FloatLE  (f) Error ("IStreamWriter:FloatLE : Not implemented.")  end
function self:DoubleLE (f) Error ("IStreamWriter:DoubleLE : Not implemented.") end

function self:FloatBE  (f) Error ("IStreamWriter:FloatBE : Not implemented.")  end
function self:DoubleBE (f) Error ("IStreamWriter:DoubleBE : Not implemented.") end

function self:Boolean  (b) Error ("IStreamWriter:Boolean : Not implemented.")  end

function self:Bytes (data, length)
	Error ("IStreamWriter:Bytes : Not implemented.")
end

function self:StringN8    (s) Error ("IStreamWriter:StringN8 : Not implemented.")    end
function self:StringN16   (s) Error ("IStreamWriter:StringN16 : Not implemented.")   end
function self:StringN32   (s) Error ("IStreamWriter:StringN32 : Not implemented.")   end
                              
function self:StringN8LE  (s) Error ("IStreamWriter:StringN8LE : Not implemented.")  end
function self:StringN16LE (s) Error ("IStreamWriter:StringN16LE : Not implemented.") end
function self:StringN32LE (s) Error ("IStreamWriter:StringN32LE : Not implemented.") end
                              
function self:StringN8BE  (s) Error ("IStreamWriter:StringN8BE : Not implemented.")  end
function self:StringN16BE (s) Error ("IStreamWriter:StringN16BE : Not implemented.") end
function self:StringN32BE (s) Error ("IStreamWriter:StringN32BE : Not implemented.") end
                              
function self:StringZ     (s) Error ("IStreamWriter:StringZ : Not implemented.")     end

local self = {}
IO.StreamReader = Class (self, IO.IStreamReader)

local string_char = string.char

function self:ctor ()
	self.Endianness = nil
	
	self:SetEndianness (IO.Endianness.LittleEndian)
end
function self:GetEndianness ()
	return self.Endianness
end

function self:SetEndianness (endianness)
	if self.Endianness == endianness then return self end
	
	self.Endianness = endianness
	
	if self.Endianness == IO.Endianness.LittleEndian then
		self.UInt16    = self.UInt16LE
		self.UInt32    = self.UInt32LE
		self.UInt64    = self.UInt64LE
		self.Int16     = self.Int16LE
		self.Int32     = self.Int32LE
		self.Int64     = self.Int64LE
		self.Float     = self.FloatLE
		self.Double    = self.DoubleLE
		self.StringN8  = self.StringN8LE
		self.StringN16 = self.StringN16LE
		self.StringN32 = self.StringN32LE
	else
		self.UInt16    = self.UInt16BE
		self.UInt32    = self.UInt32BE
		self.UInt64    = self.UInt64BE
		self.Int16     = self.Int16BE
		self.Int32     = self.Int32BE
		self.Int64     = self.Int64BE
		self.Float     = self.FloatBE
		self.Double    = self.DoubleBE
		self.StringN8  = self.StringN8BE
		self.StringN16 = self.StringN16BE
		self.StringN32 = self.StringN32BE
	end
	
	return self
end

function self:UInt8    () local uint80 = self:UInt81 () return BitConverter.UInt8sToUInt8 (uint80 or 0) end
function self:UInt8LE  () local uint80 = self:UInt81 () return BitConverter.UInt8sToUInt8 (uint80 or 0) end
function self:UInt8BE  () local uint80 = self:UInt81 () return BitConverter.UInt8sToUInt8 (uint80 or 0) end
function self:Int8     () local uint80 = self:UInt81 () return BitConverter.UInt8sToInt8  (uint80 or 0) end
function self:Int8LE   () local uint80 = self:UInt81 () return BitConverter.UInt8sToInt8  (uint80 or 0) end
function self:Int8BE   () local uint80 = self:UInt81 () return BitConverter.UInt8sToInt8  (uint80 or 0) end

function self:UInt16LE () local uint80, uint81 = self:UInt82 () return BitConverter.UInt8sToUInt16 (uint80 or 0, uint81 or 0) end
function self:UInt16BE () local uint80, uint81 = self:UInt82 () return BitConverter.UInt8sToUInt16 (uint81 or 0, uint80 or 0) end
function self:Int16LE  () local uint80, uint81 = self:UInt82 () return BitConverter.UInt8sToInt16  (uint80 or 0, uint81 or 0) end
function self:Int16BE  () local uint80, uint81 = self:UInt82 () return BitConverter.UInt8sToInt16  (uint81 or 0, uint80 or 0) end

function self:UInt32LE () local uint80, uint81, uint82, uint83 = self:UInt84 () return BitConverter.UInt8sToUInt32 (uint80 or 0, uint81 or 0, uint82 or 0, uint83 or 0) end
function self:UInt32BE () local uint80, uint81, uint82, uint83 = self:UInt84 () return BitConverter.UInt8sToUInt32 (uint83 or 0, uint82 or 0, uint81 or 0, uint80 or 0) end
function self:Int32LE  () local uint80, uint81, uint82, uint83 = self:UInt84 () return BitConverter.UInt8sToInt32  (uint80 or 0, uint81 or 0, uint82 or 0, uint83 or 0) end
function self:Int32BE  () local uint80, uint81, uint82, uint83 = self:UInt84 () return BitConverter.UInt8sToInt32  (uint83 or 0, uint82 or 0, uint81 or 0, uint80 or 0) end

function self:UInt64LE () local uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87 = self:UInt88 () return BitConverter.UInt8sToUInt64 (uint80 or 0, uint81 or 0, uint82 or 0, uint83 or 0, uint84 or 0, uint85 or 0, uint86 or 0, uint87 or 0) end
function self:UInt64BE () local uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87 = self:UInt88 () return BitConverter.UInt8sToUInt64 (uint87 or 0, uint86 or 0, uint85 or 0, uint84 or 0, uint83 or 0, uint82 or 0, uint81 or 0, uint80 or 0) end
function self:Int64LE  () local uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87 = self:UInt88 () return BitConverter.UInt8sToInt64  (uint80 or 0, uint81 or 0, uint82 or 0, uint83 or 0, uint84 or 0, uint85 or 0, uint86 or 0, uint87 or 0) end
function self:Int64BE  () local uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87 = self:UInt88 () return BitConverter.UInt8sToInt64  (uint87 or 0, uint86 or 0, uint85 or 0, uint84 or 0, uint83 or 0, uint82 or 0, uint81 or 0, uint80 or 0) end

function self:FloatLE () return BitConverter.UInt32ToFloat (self:UInt32LE ()) end
function self:FloatBE () return BitConverter.UInt32ToFloat (self:UInt32BE ()) end

function self:DoubleLE ()
	local low  = self:UInt32LE ()
	local high = self:UInt32LE ()
	return BitConverter.UInt32sToDouble (low, high)
end

function self:DoubleBE ()
	local high = self:UInt32BE ()
	local low  = self:UInt32BE ()
	return BitConverter.UInt32sToDouble (low, high)
end

function self:Boolean ()
	return self:UInt8 () ~= 0
end

function self:Bytes (length)
	return self:Read (length)
end

function self:StringN8LE  () return self:Bytes (self:UInt8LE  ()) end
function self:StringN16LE () return self:Bytes (self:UInt16LE ()) end
function self:StringN32LE () return self:Bytes (self:UInt32LE ()) end
function self:StringN8BE  () return self:Bytes (self:UInt8BE  ()) end
function self:StringN16BE () return self:Bytes (self:UInt16BE ()) end
function self:StringN32BE () return self:Bytes (self:UInt32BE ()) end

function self:StringZ ()
	local data = ""
	local c = self:UInt8 ()
	while c and c ~= 0 do
		if #data > 65536 then
			Error ("StreamReader:StringZ : String is too long, infinite loop?")
			break
		end
		
		data = data .. string_char (c)
		c = self:UInt8 ()
	end
	
	return data
end
function self:UInt81 () Error ("StreamReader:UInt81 : Not implemented.") end
function self:UInt82 () Error ("StreamReader:UInt82 : Not implemented.") end
function self:UInt84 () Error ("StreamReader:UInt84 : Not implemented.") end
function self:UInt88 () Error ("StreamReader:UInt88 : Not implemented.") end

local self = {}
IO.StreamWriter = Class (self, IO.IStreamWriter)

local string_byte = string.byte

function self:ctor ()
	self.Endianness = nil
	
	self:SetEndianness (IO.Endianness.LittleEndian)
end
function self:GetEndianness ()
	return self.Endianness
end

function self:SetEndianness (endianness)
	if self.Endianness == endianness then return self end
	
	self.Endianness = endianness
	
	if self.Endianness == IO.Endianness.LittleEndian then
		self.UInt16    = self.UInt16LE
		self.UInt32    = self.UInt32LE
		self.UInt64    = self.UInt64LE
		self.Int16     = self.Int16LE
		self.Int32     = self.Int32LE
		self.Int64     = self.Int64LE
		self.Float     = self.FloatLE
		self.Double    = self.DoubleLE
		self.StringN8  = self.StringN8LE
		self.StringN16 = self.StringN16LE
		self.StringN32 = self.StringN32LE
	else
		self.UInt16    = self.UInt16BE
		self.UInt32    = self.UInt32BE
		self.UInt64    = self.UInt64BE
		self.Int16     = self.Int16BE
		self.Int32     = self.Int32BE
		self.Int64     = self.Int64BE
		self.Float     = self.FloatBE
		self.Double    = self.DoubleBE
		self.StringN8  = self.StringN8BE
		self.StringN16 = self.StringN16BE
		self.StringN32 = self.StringN32BE
	end
	
	return self
end

function self:UInt8    (n) local uint80 = BitConverter.UInt8ToUInt8s (n) self:UInt81 (uint80) end
function self:UInt8LE  (n) local uint80 = BitConverter.UInt8ToUInt8s (n) self:UInt81 (uint80) end
function self:UInt8BE  (n) local uint80 = BitConverter.UInt8ToUInt8s (n) self:UInt81 (uint80) end
function self:Int8     (n) local uint80 = BitConverter.Int8ToUInt8s  (n) self:UInt81 (uint80) end
function self:Int8LE   (n) local uint80 = BitConverter.Int8ToUInt8s  (n) self:UInt81 (uint80) end
function self:Int8BE   (n) local uint80 = BitConverter.Int8ToUInt8s  (n) self:UInt81 (uint80) end

function self:UInt16LE (n) local uint80, uint81 = BitConverter.UInt16ToUInt8s (n) self:UInt82 (uint80, uint81) end
function self:UInt16BE (n) local uint80, uint81 = BitConverter.UInt16ToUInt8s (n) self:UInt82 (uint81, uint80) end
function self:Int16LE  (n) local uint80, uint81 = BitConverter.Int16ToUInt8s  (n) self:UInt82 (uint80, uint81) end
function self:Int16BE  (n) local uint80, uint81 = BitConverter.Int16ToUInt8s  (n) self:UInt82 (uint81, uint80) end

function self:UInt32LE (n) local uint80, uint81, uint82, uint83 = BitConverter.UInt32ToUInt8s (n) self:UInt84 (uint80, uint81, uint82, uint83) end
function self:UInt32BE (n) local uint80, uint81, uint82, uint83 = BitConverter.UInt32ToUInt8s (n) self:UInt84 (uint83, uint82, uint81, uint80) end
function self:Int32LE  (n) local uint80, uint81, uint82, uint83 = BitConverter.Int32ToUInt8s  (n) self:UInt84 (uint80, uint81, uint82, uint83) end
function self:Int32BE  (n) local uint80, uint81, uint82, uint83 = BitConverter.Int32ToUInt8s  (n) self:UInt84 (uint83, uint82, uint81, uint80) end

function self:UInt64LE (n) local uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87 = BitConverter.UInt64ToUInt8s (n) self:UInt88 (uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87) end
function self:UInt64BE (n) local uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87 = BitConverter.UInt64ToUInt8s (n) self:UInt88 (uint87, uint86, uint85, uint84, uint83, uint82, uint81, uint80) end
function self:Int64LE  (n) local uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87 = BitConverter.Int64ToUInt8s  (n) self:UInt88 (uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87) end
function self:Int64BE  (n) local uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87 = BitConverter.Int64ToUInt8s  (n) self:UInt88 (uint87, uint86, uint85, uint84, uint83, uint82, uint81, uint80) end

function self:FloatLE (f) self:UInt32LE (BitConverter.FloatToUInt32 (f)) end
function self:FloatBE (f) self:UInt32BE (BitConverter.FloatToUInt32 (f)) end

function self:DoubleLE (f)
	local low, high = BitConverter.DoubleToUInt32s (f)
	self:UInt32LE (low)
	self:UInt32LE (high)
end

function self:DoubleBE (f)
	local low, high = BitConverter.DoubleToUInt32s (f)
	self:UInt32BE (high)
	self:UInt32BE (low)
end

function self:Boolean (b)
	self:UInt8 (b and 1 or 0)
end

function self:Bytes (data, length)
	return self:Write (data, length)
end

function self:StringN8LE  (s) self:UInt8LE  (#s) return self:Bytes (s) end
function self:StringN16LE (s) self:UInt16LE (#s) return self:Bytes (s) end
function self:StringN32LE (s) self:UInt32LE (#s) return self:Bytes (s) end
function self:StringN8BE  (s) self:UInt8BE  (#s) return self:Bytes (s) end
function self:StringN16BE (s) self:UInt16BE (#s) return self:Bytes (s) end
function self:StringN32BE (s) self:UInt32BE (#s) return self:Bytes (s) end

function self:StringZ (s)
	self:Bytes (s)
	self:UInt8 (0x00)
end
function self:UInt81 (uint80)                                                         Error ("StreamWriter:UInt81 : Not implemented.") end
function self:UInt82 (uint80, uint81)                                                 Error ("StreamWriter:UInt82 : Not implemented.") end
function self:UInt84 (uint80, uint81, uint82, uint83)                                 Error ("StreamWriter:UInt84 : Not implemented.") end
function self:UInt88 (uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87) Error ("StreamWriter:UInt88 : Not implemented.") end

local self = {}
IO.StringInputStream = Class (self, IO.StreamReader)

local string_byte = string.byte
local string_find = string.find
local string_sub  = string.sub

function self:ctor (data)
	self.Data     = data
	self.Size     = #data
	
	self.Position = 0
end
function self:Close ()
	self.Data = ""
end

function self:GetPosition ()
	return self.Position
end

function self:GetSize ()
	return self.Size
end

function self:SeekAbsolute (seekPos)
	seekPos = math.min (seekPos, self:GetSize ())
	self.Position = seekPos
end
function self:Read (length)
	local data = string_sub (self.Data, self.Position + 1, self.Position + length)
	self.Position = self.Position + length
	return data
end
function self:StringZ ()
	local terminatorPosition = string_find (self.Data, "\0", self.Position + 1, true)
	if terminatorPosition then
		local str = string_sub (self.Data, self.Position + 1, terminatorPosition - 1)
		self.Position = terminatorPosition
		return str
	else
		local str = string_sub (self.Data, self.Position + 1)
		self.Position = #self.Data
		return str
	end
end
function self:UInt81 ()
	local uint80 = string_byte (self.Data, self.Position + 1, self.Position + 1)
	self.Position = self.Position + 1
	return uint80
end

function self:UInt82 ()
	local uint80, uint81 = string_byte (self.Data, self.Position + 1, self.Position + 2)
	self.Position = self.Position + 2
	return uint80, uint81
end

function self:UInt84 ()
	local uint80, uint81, uint82, uint83 = string_byte (self.Data, self.Position + 1, self.Position + 4)
	self.Position = self.Position + 4
	return uint80, uint81, uint82, uint83
end

function self:UInt88 ()
	local uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87 = string_byte (self.Data, self.Position + 1, self.Position + 8)
	self.Position = self.Position + 8
	return uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87
end

local self = {}
IO.StringOutputStream = Class (self, IO.StreamWriter)

local string_char = string.char
local string_sub  = string.sub

function self:ctor ()
	self.FlattenedData = ""
	self.Data          = {}
	self.DataPosition  = 0
	self.Position      = 0
end
function self:Close ()
	self:Clear ()
end

function self:GetPosition ()
	return self.Position
end

function self:GetSize ()
	return math.max (#self.FlattenedData, self.Position)
end

function self:SeekAbsolute (seekPos)
	if self.Position == seekPos then return end
	
	self:Flatten ()
	
	self.DataPosition = seekPos
	self.Position     = seekPos
end
function self:Write (data, length)
	length = length or #data
	
	if length < #data then
		data = string_sub (data, 1, length)
	end
	
	self.Data [#self.Data + 1] = data
	self.Position = self.Position + length
end
function self:UInt81 (uint80)
	self.Data [#self.Data + 1] = string_char (uint80)
	self.Position = self.Position + 1
end

function self:UInt82 (uint80, uint81)
	self.Data [#self.Data + 1] = string_char (uint80, uint81)
	self.Position = self.Position + 2
end

function self:UInt84 (uint80, uint81, uint82, uint83)
	self.Data [#self.Data + 1] = string_char (uint80, uint81, uint82, uint83)
	self.Position = self.Position + 4
end

function self:UInt88 (uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87)
	self.Data [#self.Data + 1] = string_char (uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87)
	self.Position = self.Position + 8
end
function self:Clear ()
	self.FlattenedData = ""
	self.Data          = {}
	self.DataPosition  = 0
	self.Position      = 0
end

function self:ToString ()
	self:Flatten ()
	
	return self.FlattenedData
end
function self:Flatten ()
	if #self.Data == 0 then return end
	
	local data = table.concat (self.Data)
	self.FlattenedData = string.sub (self.FlattenedData, 1, self.DataPosition) .. data .. string.sub (self.FlattenedData, self.Position + 1)
	
	self.Data = {}
	self.DataPosition = self.Position
end


local GarrysMod = IO
local self = {}
GarrysMod.FileInputStream = Class (self, IO.StreamReader)

function GarrysMod.FileInputStream.FromPath (path, pathId)
	local f = file.Open (path, "rb", pathId)
	if not f then return nil end
	
	return GarrysMod.FileInputStream (f)
end

function self:ctor (file)
	self.File = file
end
function self:Close ()
	if not self.File then return end
	
	self.File:Close ()
	self.File = nil
end

function self:GetPosition ()
	return self.File:Tell ()
end

function self:GetSize ()
	return self.File:Size ()
end

function self:SeekAbsolute (seekPos)
	seekPos = math.min (seekPos, self:GetSize ())
	self.File:Seek (seekPos)
end
function self:Read (length)
	return self.File:Read (length) or ""
end
function self:UInt8   () return self.File:ReadByte () or 0 end
function self:UInt8LE () return self.File:ReadByte () or 0 end
function self:UInt8BE () return self.File:ReadByte () or 0 end

function self:Int8   () local n = self.File:ReadByte () or 0 if n >= 128 then n = n - 256 end return n end
function self:Int8LE () local n = self.File:ReadByte () or 0 if n >= 128 then n = n - 256 end return n end
function self:Int8BE () local n = self.File:ReadByte () or 0 if n >= 128 then n = n - 256 end return n end

function self:UInt16LE () local n = self.File:ReadShort () or 0 if n < 0 then n = n + 65536 end return n end

function self:Int16LE () return self.File:ReadShort () or 0 end

function self:UInt32LE () local n = self.File:ReadLong () or 0 if n < 0 then n = n + 4294967296 end return n end

function self:Int32LE () return self.File:ReadLong () or 0 end

function self:FloatLE  () return self.File:ReadFloat  () or 0 end
function self:DoubleLE () return self.File:ReadDouble () or 0 end
function self:UInt81 ()
	local uint8 = self.File:ReadByte () or 0
	local uint80 = BitConverter.UInt8ToUInt8s (uint8)
	return uint80
end

function self:UInt82 ()
	local int16 = self.File:ReadShort () or 0
	local uint80, uint81 = BitConverter.Int16ToUInt8s (int16)
	return uint80, uint81
end

function self:UInt84 ()
	local int32 = self.File:ReadLong () or 0
	local uint80, uint81, uint82, uint83 = BitConverter.Int32ToUInt8s (int32)
	return uint80, uint81, uint82, uint83
end

function self:UInt88 ()
	local uint80, uint81, uint82, uint83 = self:UInt84 ()
	local uint84, uint85, uint86, uint87 = self:UInt84 ()
	return uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87
end

local self = {}
GarrysMod.FileOutputStream = Class (self, IO.StreamWriter)

function GarrysMod.FileOutputStream.FromPath (path, pathId)
	local f = file.Open (path, "wb", pathId)
	if not f then return nil end
	
	return GarrysMod.FileOutputStream (f)
end

function self:ctor (file)
	self.File = file
	
	self.Size = 0
end
function self:Close ()
	if not self.File then return end
	
	self.File:Close ()
	self.File = nil
end

function self:GetPosition ()
	return self.File:Tell ()
end

function self:GetSize ()
	self.Size = math.max (self.Size, self:GetPosition ())
	return self.Size
end

function self:SeekAbsolute (seekPos)
	seekPos = math.min (seekPos, self:GetSize ())
	self.File:Seek (seekPos)
end
function self:Write (data, length)
	length = length or #data
	
	if length < #data then
		data = string.sub (data, 1, length)
	end
	
	self.File:Write (data)
end	
function self:UInt8   (n) self.File:WriteByte (n) end
function self:UInt8LE (n) self.File:WriteByte (n) end
function self:UInt8BE (n) self.File:WriteByte (n) end

function self:Int8   (n) if n < 0 then n = n + 256 end self.File:WriteByte (n) end
function self:Int8LE (n) if n < 0 then n = n + 256 end self.File:WriteByte (n) end
function self:Int8BE (n) if n < 0 then n = n + 256 end self.File:WriteByte (n) end

function self:UInt16LE (n) if n >= 32768 then n = n - 65536 end self.File:WriteShort (n) end

function self:Int16LE (n) self.File:WriteShort (n) end

function self:UInt32LE (n) if n >= 2147483648 then n = n - 4294967296 end self.File:WriteLong (n) end

function self:Int32LE (n) self.File:WriteLong (n) end

function self:FloatLE  (f) self.File:WriteFloat  (f) end
function self:DoubleLE (f) self.File:WriteDouble (f) end
function self:UInt81 (uint80)
	local uint8 = BitConverter.UInt8sToUInt8 (uint80)
	self.File:WriteByte (uint8)
end

function self:UInt82 (uint80, uint81)
	local int16 = BitConverter.UInt8sToInt16 (uint80, uint81)
	self.File:WriteShort (int16)
end

function self:UInt84 (uint80, uint81, uint82, uint83)
	local int32 = BitConverter.UInt8sToInt32 (uint80, uint81, uint82, uint83)
	self.File:WriteLong (int32)
end

function self:UInt88 (uint80, uint81, uint82, uint83, uint84, uint85, uint86, uint87)
	self:UInt84 (uint80, uint81, uint82, uint83)
	self:UInt84 (uint84, uint85, uint86, uint87)
end




local PublicKey = {}


PublicKey.Raw = [[
--
Comment: "packages.garrysmod.io"
AAAAB3NzaC1yc2EAAAABJQAAAIEAlwd31/n5mkgP0Mgf2EUncxaX7bo8NwZW6Eqt
g8l/R8Ir9fCrQ73QnJsg2UpEBQ2PySVpZqNmUsCOCCTT/Gz11PC19qA8+6VORan+
ifa9gci12J1eJd30uWAji1pTRl6vnYWKtsYoP5i0IYbGb6RKALjKmUxNjvHJA12S
tyj4iB0=
--
]]

local base64 = string.match (PublicKey.Raw, "^%-%-[^\n]*\nComment:[^\n]+\n([A-Za-z0-9%+/%s]+=?=?)\n%-%-.*$")

local inputStream = IO.StringInputStream (Base64.Decode (base64))
inputStream:Bytes (inputStream:UInt32BE ())
PublicKey.Exponent = BigInteger.FromBlob (inputStream:Bytes (inputStream:UInt32BE ()))
PublicKey.Modulus  = BigInteger.FromBlob (inputStream:Bytes (inputStream:UInt32BE ()))
inputStream:Close ()

local PublicKey = PublicKey

local Verification = {}


local self = {}
Verification.LuaFile = Class (self, ISerializable)

function Verification.LuaFile.Deserialize (streamReader, extended)
	local luaFile = Verification.LuaFile (nil, extended)
	luaFile:Deserialize (streamReader)
	return luaFile
end

function self:ctor (path, extended)
	self.Extended = extended or false
	
	self.Path = path
	self.CRC32 = 0
	self.LastModificationTime = 0
	self.Size = 0
	
	self.DynamicCode = false
	
	self.FunctionCount = 0
	
	self.StartLines = {}
	self.EndLines   = {}
	self.MD5s       = {}
	
	if self.Extended then
		self.CRC32s  = {}
		self.SHA256s = {}
	end
end
function self:Serialize (streamWriter)
	streamWriter:StringN16 (self.Path)
	streamWriter:UInt32 (self.CRC32)
	streamWriter:UInt64 (self.LastModificationTime)
	streamWriter:UInt64 (self.Size)
	streamWriter:Boolean (self.DynamicCode)
	streamWriter:UInt32 (self.FunctionCount)
	
	for i = 1, self.FunctionCount do
		streamWriter:UInt32 (self.StartLines [i])
		streamWriter:UInt32 (self.EndLines   [i])
		streamWriter:Bytes (self.MD5s [i])
		
		if self.Extended then
			streamWriter:UInt32 (self.CRC32s [i])
			streamWriter:Bytes (self.SHA256s [i])
		end
	end
end

function self:Deserialize (streamReader)
	self.Path                 = streamReader:StringN16 ()
	self.CRC32                = streamReader:UInt32 ()
	self.LastModificationTime = streamReader:UInt64 ()
	self.Size                 = streamReader:UInt64 ()
	self.DynamicCode          = streamReader:Boolean ()
	self.FunctionCount        = streamReader:UInt32 ()
	
	for i = 1, self.FunctionCount do
		self.StartLines [i] = streamReader:UInt32 ()
		self.EndLines   [i] = streamReader:UInt32 ()
		self.MD5s       [i] = streamReader:Bytes (16)
		
		if self.Extended then
			self.CRC32s  [i] = streamReader:UInt32 ()
			self.SHA256s [i] = streamReader:Bytes (32)
		end
	end
end
function self:AddCode (code)
	local f, err = loadstring (code, self.Path)
	if not f then return false, err end
	
	self:AddDump (string.dump (f))
	
	return true
end

function self:AddDump (dump)
	local inputStream = IO.StringInputStream (dump)
	if string.find (dump, "(loadstring|CompileString|RunString)") then
		self.DynamicCode = true
	end
	inputStream:Bytes (4) 
	inputStream:UInt8 ()  
	
	inputStream:Bytes (ULEB128.Deserialize (inputStream)) 
	local functionDataLength = ULEB128.Deserialize (inputStream)
	while functionDataLength ~= 0 do
		local nextPosition = inputStream:GetPosition () + functionDataLength
		self:AddFunctionDump (inputStream)
		inputStream:SeekAbsolute (nextPosition)
		functionDataLength = ULEB128.Deserialize (inputStream)
	end
end

function self:AddFunctionDump (inputStream)
	inputStream:UInt8   () 
	inputStream:UInt8   () 
	inputStream:UInt8   () 
	inputStream:UInt8   () 
	ULEB128.Deserialize (inputStream) 
	ULEB128.Deserialize (inputStream) 
	
	local instructionCount = ULEB128.Deserialize (inputStream) 
	
	ULEB128.Deserialize (inputStream) 
	
	local startLine = ULEB128.Deserialize (inputStream)
	local lineCount = ULEB128.Deserialize (inputStream)
	local normalizedBytecode = Verification.NormalizedBytecodeFromBytecodeDump (inputStream:Bytes (instructionCount * 4))
	
	self.FunctionCount = self.FunctionCount + 1
	self.StartLines [#self.StartLines + 1] = startLine
	self.EndLines   [#self.EndLines   + 1] = startLine + lineCount
	self.MD5s       [#self.MD5s       + 1] = String.FromHex (Crypto.MD5.Compute (normalizedBytecode))
	
	if self.Extended then
		self.CRC32s  [#self.CRC32s  + 1] = CRC32 (normalizedBytecode)
		self.SHA256s [#self.SHA256s + 1] = String.FromHex (Crypto.SHA256.Compute (normalizedBytecode))
	end
end

function self:GetPath ()
	return self.Path
end

function self:GetCRC32 ()
	return self.CRC32
end

function self:GetLastModificationTime ()
	return self.LastModificationTime
end

function self:GetSize ()
	return self.Size
end

function self:GetFunction (i)
	return self.StartLines [i], self.EndLines [i], self.MD5s [i], self.CRC32s [i], self.SHA256s [i]
end

function self:GetFunctionCount ()
	return self.FunctionCount
end

function self:GetSerializationLength ()
	if self.Extended then
		return 2 + #self.Path + 4 + 4 + 4 + 1 + 4 + self.FunctionCount * (4 + 4 + 16 + 4 + 32)
	else
		return 2 + #self.Path + 4 + 4 + 4 + 1 + 4 + self.FunctionCount * (4 + 4 + 16)
	end
end

function self:SetCRC32 (crc32)
	self.CRC32 = crc32
end

function self:SetLastModificationTime (lastModificationTime)
	self.LastModificationTime = lastModificationTime
end

function self:SetSize (size)
	self.Size = size
end


local PackageFile = {}
local self = {}
PackageFile = Class (self, ISerializable)
PackageFile.Signature     = "\xffPKG\r\n\x1a\n"
PackageFile.FormatVersion = 1

function PackageFile.Deserialize (streamReader, exponent, modulus)
	local signature = streamReader:Bytes (#PackageFile.Signature)
	if signature ~= PackageFile.Signature then return nil end
	
	local formatVersion = streamReader:UInt32 ()
	if formatVersion == PackageFile.FormatVersion then
		local name    = streamReader:StringN8 ()
		local version = streamReader:StringN8 ()
		local packageFile = PackageFile (name, version)
		streamReader:UInt64 ()
		
		local sectionPositions = {}
		local sectionLengths   = {}
		
		local sectionCount = streamReader:UInt32 ()
		for i = 1, sectionCount do
			local startPosition = streamReader:GetPosition ()
			local name   = streamReader:StringN8 ()
			local length = streamReader:UInt32 ()
			sectionLengths [name] = streamReader:GetPosition () - startPosition + length
			sectionPositions [name] = startPosition
			
			local section = nil
			if name == PackageFile.DependenciesSection.Name then
				section = PackageFile.DependenciesSection ()
			elseif name == PackageFile.FileSystemSection.Name then
				section = PackageFile.FileSystemSection ()
			elseif name == PackageFile.LuaHashesSection.Name then
				section = PackageFile.LuaHashesSection ()
			elseif name == PackageFile.SignatureSection.Name then
				section = PackageFile.SignatureSection ()
			else
				section = PackageFile.UnknownSection (name, streamReader:Bytes (sectionLengths [name]))
			end
			
			section:Deserialize (streamReader)
			packageFile.SectionsByName [name] = section
			packageFile.Sections [#packageFile.Sections + 1] = section
		end
		if exponent and modulus then
			local signatureSection = packageFile:GetSection ("signature")
			signatureSection:SetVerified (signatureSection:VerifySelf (name, version, exponent, modulus))
			
			if signatureSection:IsVerified () then
				local endPosition = streamReader:GetPosition ()
				for i = 1, signatureSection:GetSectionHashCount () do
					local sectionName, md5a, sha256a = signatureSection:GetSectionHash (i)
					if sectionPositions [sectionName] then
						streamReader:SeekAbsolute (sectionPositions [sectionName])
						local data = streamReader:Bytes (sectionLengths [sectionName])
						local md5b = String.FromHex (Crypto.MD5.Compute (data))
						packageFile:GetSection (sectionName):SetVerified (md5a == md5b)
					end
				end
				streamReader:SeekAbsolute (endPosition)
			end
		end
		
		return packageFile
	else
		return nil
	end
end

function self:ctor (name, version)
	self.Name           = name
	self.Version        = version
	
	self.Sections       = {}
	self.SectionsByName = {}
end
function self:Serialize (streamWriter)
	local startPosition = streamWriter:GetPosition ()
	streamWriter:Bytes    (PackageFile.Signature)
	streamWriter:UInt32   (PackageFile.FormatVersion)
	streamWriter:StringN8 (self.Name)
	streamWriter:StringN8 (self.Version)
	local fileLengthPosition = streamWriter:GetPosition ()
	streamWriter:UInt64   (0)
	streamWriter:UInt32   (#self.Sections)
	
	for section in self:GetSectionEnumerator () do
		streamWriter:StringN8 (section:GetName ())
		local lengthPosition = streamWriter:GetPosition ()
		streamWriter:UInt32 (0)
		local startPosition = streamWriter:GetPosition ()
		
		section:Serialize (streamWriter)
		local endPosition = streamWriter:GetPosition ()
		streamWriter:SeekAbsolute (lengthPosition)
		streamWriter:UInt32 (endPosition - startPosition)
		streamWriter:SeekAbsolute (endPosition)
	end
	local endPosition = streamWriter:GetPosition ()
	streamWriter:SeekAbsolute (fileLengthPosition)
	streamWriter:UInt64 (endPosition - startPosition)
	streamWriter:SeekAbsolute (endPosition)
end
function self:GetName ()
	return self.Name
end

function self:GetVersion ()
	return self.Version
end
function self:AddSection (section)
	self:RemoveSection (section:GetName ())
	
	self.Sections [#self.Sections + 1] = section
	self.SectionsByName [section:GetName ()] = section
end

function self:GetSection (indexOrName)
	return self.SectionsByName [indexOrName] or self.Sections [indexOrName]
end

function self:GetSectionCount ()
	return self.SectionCount
end

function self:GetSectionEnumerator ()
	return ArrayEnumerator (self.Sections)
end

function self:RemoveSection (name)
	local section = self.SectionsByName [name]
	
	if not section then return end
	
	for i = 1, #self.Sections do
		if self.Sections [i] == section then
			table.remove (self.Sections, i)
			break
		end
	end
end

local self = {}
PackageFile.Section = Class (self, ISerializable)

function self:ctor ()
	self.Verified = nil
end
function self:GetName ()
	Error ("ISection:GetName : Not implemented.")
end

function self:IsVerified ()
	return self.Verified
end

function self:SetVerified (verified)
	self.Verified = verified
end

local self = {}
PackageFile.UnknownSection = Class (self, PackageFile.Section)

function self:ctor (name, data)
	self.Name = name
	self.Data = data or ""
end
function self:Serialize (streamWriter)
	streamWriter:Bytes (self.Data)
end

function self:Deserialize (streamReader)
end
function self:GetName ()
	return self.Name
end
function self:GetData ()
	return self.Data
end

function self:SetData (data)
	self.Data = data
end

local self = {}
PackageFile.DependenciesSection = Class (self, PackageFile.Section)
PackageFile.DependenciesSection.Name = "dependencies"

function self:ctor ()
	self.DependencyNames    = {}
	self.DependencyVersions = {}
end
function self:Serialize (streamWriter)
	streamWriter:UInt32 (#self.DependencyNames)
	for i = 1, #self.DependencyNames do
		streamWriter:StringN8 (self.DependencyNames    [i])
		streamWriter:StringN8 (self.DependencyVersions [i])
	end
end

function self:Deserialize (streamReader)
	local dependencyCount = streamReader:UInt32 ()
	for i = 1, dependencyCount do
		local dependencyName    = streamReader:StringN8 ()
		local dependencyVersion = streamReader:StringN8 ()
		self:AddDependency (dependencyName, dependencyVersion)
	end
end
function self:GetName ()
	return PackageFile.DependenciesSection.Name
end
function self:AddDependency (name, version)
	self.DependencyNames    [#self.DependencyNames    + 1] = name
	self.DependencyVersions [#self.DependencyVersions + 1] = version
end

function self:GetDependency (i)
	return self.DependencyNames [i], self.DependencyVersions [i]
end

function self:GetDependencyCount ()
	return #self.DependencyNames
end

local self = {}
PackageFile.FileSystemSection = Class (self, PackageFile.Section)
PackageFile.FileSystemSection.Name = "code"

function self:ctor ()
	self.Files       = {}
	self.FilesByPath = {}
end
function self:Serialize (streamWriter)
	streamWriter:UInt32 (#self.Files)
	for file in self:GetFileEnumerator () do
		file:Serialize (streamWriter)
	end
end

function self:Deserialize (streamReader)
	local fileCount = streamReader:UInt32 ()
	for i = 1, fileCount do
		local file = PackageFile.FileSystemFile.Deserialize (streamReader)
		self:AddFile (file)
	end
end
function self:GetName ()
	return PackageFile.FileSystemSection.Name
end
function self:AddFile (file)
	self.Files [#self.Files + 1] = file
	self.FilesByPath [file:GetPath ()] = file
end

function self:GetFile (indexOrPath)
	return self.FilesByPath [indexOrPath] or self.Files [indexOrPath]
end

function self:GetFileCount ()
	return #self.Files
end

function self:GetFileEnumerator ()
	return ArrayEnumerator (self.Files)
end

local self = {}
PackageFile.FileSystemFile = Class (self, ISerializable)

function PackageFile.FileSystemFile.Deserialize (streamReader)
	local file = PackageFile.FileSystemFile ()
	file:Deserialize (streamReader)
	return file
end

function self:ctor ()
	self.Path = ""
	self.CRC32 = 0
	self.LastModificationTime = 0
	self.Size = 0
	self.Data = ""
end
function self:Serialize (streamWriter)
	streamWriter:StringN16 (self.Path)
	streamWriter:UInt32 (self.CRC32)
	streamWriter:UInt64 (self.LastModificationTime)
	streamWriter:UInt64 (self.Size)
	streamWriter:Bytes (self.Data)
end

function self:Deserialize (streamReader)
	self.Path                 = streamReader:StringN16 ()
	self.CRC32                = streamReader:UInt32 ()
	self.LastModificationTime = streamReader:UInt64 ()
	self.Size                 = streamReader:UInt64 ()
	self.Data                 = streamReader:Bytes (self.Size)
end
function self:GetPath ()
	return self.Path
end

function self:GetCRC32 ()
	return self.CRC32
end

function self:GetData ()
	return self.Data
end

function self:GetLastModificationTime ()
	return self.LastModificationTime
end

function self:GetSize ()
	return self.Size
end

function self:GetSerializationLength ()
	return 2 + #self.Path + 4 + 8 + 8 + self.Size
end

local self = {}
PackageFile.LuaHashesSection = Class (self, PackageFile.Section)
PackageFile.LuaHashesSection.Name = "luahashes"

function self:ctor ()
	self.LuaFiles       = {}
	self.LuaFilesByPath = {}
end
function self:Serialize (streamWriter)
	streamWriter:UInt32 (#self.LuaFiles)
	for luaFile in self:GetLuaFileEnumerator () do
		luaFile:Serialize (streamWriter)
	end
end

function self:Deserialize (streamReader)
	local luaFileCount = streamReader:UInt32 ()
	for i = 1, luaFileCount do
		local luaFile = Verification.LuaFile.Deserialize (streamReader, true)
		self:AddLuaFile (luaFile)
	end
end
function self:GetName ()
	return PackageFile.LuaHashesSection.Name
end
function self:AddLuaFile (luaFile)
	self.LuaFiles [#self.LuaFiles + 1] = luaFile
	self.LuaFilesByPath [luaFile:GetPath ()] = luaFile
end

function self:GetLuaFile (indexOrPath)
	return self.LuaFilesByPath [indexOrPath] or self.LuaFiles [indexOrPath]
end

function self:GetLuaFileCount ()
	return #self.LuaFiles
end

function self:GetLuaFileEnumerator ()
	return ArrayEnumerator (self.LuaFiles)
end

local self = {}
PackageFile.SignatureSection = Class (self, PackageFile.Section)
PackageFile.SignatureSection.Name = "signature"

function self:ctor ()
	self.SectionHashBlob = nil
	self.SectionNames    = {}
	self.SectionMD5s     = {}
	self.SectionSHA256s  = {}
end
function self:Serialize (streamWriter)
	streamWriter:StringN32 (self.Signature)
	
	streamWriter:UInt32 (#self.SectionNames)
	for i = 1, #self.SectionNames do
		streamWriter:StringN8 (self.SectionNames   [i])
		streamWriter:Bytes    (self.SectionMD5s    [i])
		streamWriter:Bytes    (self.SectionSHA256s [i])
	end
end

function self:Deserialize (streamReader)
	self.Signature = streamReader:StringN32 ()
	
	local startPosition = streamReader:GetPosition ()
	local sectionHashCount = streamReader:UInt32 ()
	for i = 1, sectionHashCount do
		local sectionName = streamReader:StringN8 ()
		local md5         = streamReader:Bytes (16)
		local sha256      = streamReader:Bytes (32)
		self:AddSectionHash (sectionName, md5, sha256)
	end
	local endPosition = streamReader:GetPosition ()
	streamReader:SeekAbsolute (startPosition)
	self.SectionHashBlob = streamReader:Bytes (endPosition - startPosition)
	streamReader:SeekAbsolute (endPosition)
end
function self:GetName ()
	return PackageFile.SignatureSection.Name
end
function self:AddSectionHash (sectionName, md5, sha256)
	self.SectionNames   [#self.SectionNames   + 1] = sectionName
	self.SectionMD5s    [#self.SectionMD5s    + 1] = md5
	self.SectionSHA256s [#self.SectionSHA256s + 1] = sha256
end

function self:GetSectionHash (i)
	return self.SectionNames [i], self.SectionMD5s [i], self.SectionSHA256s [i]
end

function self:GetSectionHashCount ()
	return #self.SectionNames
end

function self:VerifySelf (name, version, exponent, modulus)
	if not self.SectionHashBlob then return nil end
	
	local outputStream = IO.StringOutputStream ()
	outputStream:StringN8 (name)
	outputStream:StringN8 (version)
	outputStream:Bytes (self.SectionHashBlob)
	local sha256a = Crypto.SHA256.Compute (outputStream:ToString ())
	outputStream:Close ()
	
	local sha256b = String.ToHex (string.sub (BigInteger.FromBlob (self.Signature):ExponentiateMod (exponent, modulus):ToBlob (), -32, -1))
	
	return sha256a == sha256b
end


local Carrier = {}
function Carrier.ToFileName (s)
	return string.gsub (string.lower (s), "[^%w%.%-%+_]", "_")
end

local debugColor = Color (192, 192, 192)
function Carrier.Debug (message)
	MsgC (debugColor, "Carrier: " .. message .. "\n")
end

function Carrier.Log (message)
	print ("Carrier: " .. message)
end

local warningColor = Color (255, 192, 64)
function Carrier.Warning (message)
	MsgC (warningColor, "Carrier: Warning: " .. message .. "\n")
end
local self = {}
Carrier.Packages = Class (self, ISerializable)
self.Signature     = "\xffPKG\r\n\x1a\n"
self.FormatVersion = 1

local sv_allowcslua = GetConVar ("sv_allowcslua")
local carrier_developer_sv = CreateConVar ("carrier_developer_sv", "0", FCVAR_ARCHIVE + FCVAR_REPLICATED)
local carrier_developer_cl = CLIENT and CreateClientConVar ("carrier_developer_cl", "0", true, false) or nil
local carrier_developer    = CLIENT and carrier_developer_cl or carrier_developer_sv

function self:ctor ()
	self.Packages     = {}
	self.PackageCount = 0
	
	self.ManifestLoaded = false
	self.ManifestTimestamp = 0
	self.Path           = "garrysmod.io/carrier/packages.dat"
	self.CacheDirectory = "garrysmod.io/carrier/cache"
	file.CreateDir (self.CacheDirectory)
	
	self.ServerLoadRoots = {}
	self.ClientLoadRoots = {}
	self.LocalLoadRoots  = nil
	self.LoadedPackages  = {}
	
	self:UpdateLocalDeveloperPackages ()
end
function self:Serialize (streamWriter)
	streamWriter:Bytes  (self.Signature)
	streamWriter:UInt32 (self.FormatVersion)
	streamWriter:UInt32 (0)
	streamWriter:UInt64 (self.ManifestTimestamp)
	
	streamWriter:UInt32 (self.PackageCount)
	for package in self:GetPackageEnumerator () do
		streamWriter:StringN8 (package:GetName ())
		package:Serialize (streamWriter)
	end
	
	streamWriter:SeekAbsolute (#self.Signature + 4)
	streamWriter:UInt32 (streamWriter:GetSize ())
	
	return true
end

function self:Deserialize (streamReader)
	local signature = streamReader:Bytes (#self.Signature)
	if signature ~= self.Signature then return false end
	
	local formatVersion = streamReader:UInt32 ()
	if formatVersion ~= self.FormatVersion then return false end
	
	local length = streamReader:UInt32 ()
	if length ~= streamReader:GetSize () then return false end
	
	self.ManifestTimestamp = streamReader:UInt64 ()
	local packageCount = streamReader:UInt32 ()
	for i = 1, packageCount do
		local packageName = streamReader:StringN8 ()
		local package = self:GetPackage (packageName) or Carrier.Package (packageName)
		self:AddPackage (package)
		
		package:Deserialize (streamReader)
	end
	
	return true
end
function self:IsLocalDeveloperEnabled ()
	return carrier_developer:GetBool () and (SERVER or sv_allowcslua:GetBool ())
end

function self:IsServerDeveloperEnabled ()
	return carrier_developer_sv:GetBool () and util.NetworkStringToID ("Carrier.RequestDeveloperPackageList") ~= 0
end
function self:Initialize ()
	local t0 = SysTime ()
	if not self:IsMetadataLoaded () then
		self:LoadMetadata ()
	end
	
	self.ServerLoadRoots = self:GetLoadRoots ("carrier/autoload/server/", self.ServerLoadRoots)
	self.ClientLoadRoots = self:GetLoadRoots ("carrier/autoload/client/", self.ClientLoadRoots)
	
	local sharedLoadRoots = self:GetLoadRoots ("carrier/autoload/")
	for packageName, _ in pairs (sharedLoadRoots) do
		self.ServerLoadRoots [packageName] = true
		self.ClientLoadRoots [packageName] = true
	end
	
	self.LocalLoadRoots = CLIENT and self.ClientLoadRoots or self.ServerLoadRoots
	
	if self:IsLocalDeveloperEnabled () then
		for packageName, _ in pairs (self.LocalLoadRoots) do
			self:Load (packageName)
		end
	end
	
	Task.Run (
		function ()
			self:Update ():Await ()
			
			local downloadSet = {}
			downloadSet = self:ComputePackageDependencySet ("Carrier", downloadSet)
			for packageName, _ in pairs (self.LocalLoadRoots) do
				downloadSet = self:ComputePackageDependencySet (packageName, downloadSet)
			end
			if SERVER then
				for packageName, _ in pairs (self.ClientLoadRoots) do
					downloadSet = self:ComputePackageDependencySet (packageName, downloadSet)
				end
			end
			
			local success = true
			for packageName, packageReleaseVersion in pairs (downloadSet) do
				success = success and self:Download (packageName, packageReleaseVersion):Await ()
			end
			
			for packageName, _ in pairs (self.LocalLoadRoots) do
				self:Load (packageName)
			end
		end
	)
	
	local dt = SysTime () - t0
	Carrier.Log (string.format ("Initialize took %.2f ms", dt * 1000))
end

function self:Uninitialize ()
	for packageName, _ in pairs (self.LoadedPackages) do
		self:Unload (packageName)
	end
end
function self:SaveMetadata ()
	local outputStream = IO.FileOutputStream.FromPath (self.Path, "DATA")
	if not outputStream then
		Carrier.Warning ("Could not open " .. self.Path .. " for saving!")
		return
	end
	self:Serialize (outputStream)
	outputStream:Close ()
	
	Carrier.Log ("Saved to " .. self.Path)
end

function self:LoadMetadata ()
	local inputStream = IO.FileInputStream.FromPath (self.Path, "DATA")
	if not inputStream then return end
	local success = self:Deserialize (inputStream)
	inputStream:Close ()
	
	if success then
		self.ManifestLoaded = true
		Carrier.Log ("Loaded from " .. self.Path)
	else
		Carrier.Log ("Load from " .. self.Path .. " failed!")
	end
end

function self:IsMetadataLoaded ()
	return self.ManifestLoaded
end
function self:GetPackage (packageName)
	return self.Packages [packageName]
end

function self:GetPackageCount ()
	return self.PackageCount
end

function self:GetPackageEnumerator ()
	return ValueEnumerator (self.Packages)
end

function self:GetLocalDeveloperRelease (packageName)
	local package = self.Packages [packageName]
	
	return package and package:GetLocalDeveloperRelease ()
end

function self:GetLatestRelease (packageName)
	local package = self.Packages [packageName]
	
	return package and package:GetLatestRelease ()
end

function self:GetPackageRelease (packageName, packageReleaseVersion)
	local package = self.Packages [packageName]
	
	return package and package:GetRelease (packageReleaseVersion)
end

function self:IsPackageReleaseAvailable (packageName, packageReleaseVersion)
	local packageRelease = packageReleaseVersion and self:GetPackageRelease (packageName, packageReleaseVersion) or self:GetLatestRelease (packageName)
	return packageRelease and packageRelease:IsAvailable () or false
end

function self:IsPackageReleaseAvailableRecursive (packageName, packageReleaseVersion)
	local packageRelease = packageReleaseVersion and self:GetPackageRelease (packageName, packageReleaseVersion) or self:GetLatestRelease (packageName)
	if not packageRelease then return false end
	
	local dependencySet = self:ComputePackageReleaseDependencySet (packageRelease)
	for packageName, packageReleaseVersion in pairs (dependencySet) do
		if not self:IsPackageReleaseAvailable (packageName, packageReleaseVersion) then
			return false
		end
	end
	
	return true
end
function self:ComputePackageDependencySet (packageName, dependencySet)
	local package = self:GetPackage (packageName)
	local packageRelease = package and package:GetLatestRelease ()
	return self:ComputePackageReleaseDependencySet (packageRelease, dependencySet)
end

function self:ComputePackageReleaseDependencySet (packageRelease, dependencySet)
	local dependencySet = dependencySet or {}
	if not packageRelease then return dependencySet end
	
	dependencySet [packageRelease:GetName ()] = packageRelease:GetVersion ()
	
	for dependencyName, dependencyVersion in packageRelease:GetDependencyEnumerator () do
		if not dependencySet [dependencyName] then
			dependencySet = self:ComputePackageReleaseDependencySet (self:GetPackageRelease (dependencyName,dependencyVersion), dependencySet)
		end
	end
	
	return dependencySet
end
function self:Assimilate (package, packageRelease, environment, exports, destructor)
	package:Assimilate (packageRelease, environment, exports, destructor)
	self.LoadedPackages [package:GetName ()] = package
end

function self:Load (packageName, packageReleaseVersion)
	local package = self:GetPackage (packageName)
	if not package then
		Carrier.Warning ("Load: Package " .. packageName .. " not found!")
		return
	end
	
	if not packageReleaseVersion then
		local packageRelease = nil
		if self:IsLocalDeveloperEnabled () then
			packageRelease = packageRelease or package:GetLocalDeveloperRelease ()
		end
		packageRelease = packageRelease or package:GetLatestRelease ()
		if SERVER or sv_allowcslua:GetBool () then
			if not packageRelease or not packageRelease:IsAvailable () then
				packageRelease = package:GetLocalDeveloperRelease () or packageRelease
			end
		end
		
		packageReleaseVersion = packageRelease and packageRelease:GetVersion ()
	end
	if not packageReleaseVersion then
		Carrier.Warning ("Load: No releases found for " .. packageName .. "!")
		return
	end
	
	self.LoadedPackages [packageName] = package
	return package:Load (packageReleaseVersion)
end

function self:LoadProvider (packageName)
	return self:Load (packageName .. ".GarrysMod")
end

function self:Unload (packageName)
	local package = self.LoadedPackages [packageName]
	if not package then return end
	
	if package == true then
		Carrier.Warning ("Dependency cycle involving package " .. packageName .. "!")
		return
	end
	
	self.LoadedPackages [packageName] = true
	if package:GetLoadedRelease () then
		for dependentName, dependentVersion in package:GetLoadedRelease ():GetDependentEnumerator () do
			self:Unload (dependentName)
		end
	else
		Carrier.Warning ("Loaded release missing for " .. packageName .. ", dependencies cannot be unloaded in the right order!")
	end
	
	package:Unload ()
	self.LoadedPackages [packageName] = nil
end
function self:Download (packageName, packageReleaseVersion)
	return Task.Run (
		function ()
			local packageRelease = self:GetPackageRelease (packageName, packageReleaseVersion)
			if not packageRelease then return false end
			
			if file.Exists (self.CacheDirectory .. "/" .. packageRelease:GetFileName (), "DATA") then return true end
			
			local response
			local url = "https://garrysmod.io/api/packages/v1/download?name=" .. HTTP.EncodeUriComponent (packageName) .. "&version=" .. HTTP.EncodeUriComponent (packageReleaseVersion)
			for i = 1, 5 do
				response = HTTP.Get (url):await ()
				if response:IsSuccess () then break end
				
				if i ~= 5 then
					local delay = 1 * math.pow (2, i - 1)
					Carrier.Warning ("Failed to fetch from " .. url .. ", retrying in " .. delay .. " second(s)...")
					Async.Sleep (delay):await ()
				end
			end
			
			if not response:IsSuccess () then
				Carrier.Log ("Failed to download " .. packageName .. " " .. packageReleaseVersion)
				return false
			end
			
			if string.sub (response:GetContent (), 1, #PackageFile.Signature) == PackageFile.Signature then
				Carrier.Log ("Downloaded " .. packageName .. " " .. packageReleaseVersion)
				file.Write (self.CacheDirectory .. "/" .. packageRelease:GetFileName (), response:GetContent ())
				return true
			else
				Carrier.Log ("Downloaded " .. packageName .. " " .. packageReleaseVersion .. ", but bad signature")
				return false
			end
		end
	)
end

function self:DownloadRecursive (packageName, packageReleaseVersion)
	return Task.Run (
		function ()
			local packageRelease = packageReleaseVersion and self:GetPackageRelease (packageName, packageReleaseVersion) or self:GetLatestRelease (packageName)
			if not packageRelease then return false end
			local downloadSet = Carrier.Packages:ComputePackageReleaseDependencySet (packageRelease)
			
			for packageName, packageReleaseVersion in pairs (downloadSet) do
				local success = self:Download (packageName, packageReleaseVersion):Await ()
				if not success then return false end
			end
			
			return true
		end
	)
end

function self:Update ()
	return Task.Run (
		function ()
			local response
			for i = 1, 5 do
				response = HTTP.Get ("https://garrysmod.io/api/packages/v1/latest"):Await ()
				if response:IsSuccess () then break end
				
				if i ~= 5 then
					local delay = 1 * math.pow (2, i - 1)
					Carrier.Warning ("Failed to fetch from https://garrysmod.io/api/packages/v1/latest, retrying in " .. delay .. " second(s)...")
					Async.Sleep (delay):await ()
				end
			end
			
			if not response:IsSuccess () then
				Carrier.Warning ("Failed to download package list.")
				return false
			end
			
			local response = util.JSONToTable (response:GetContent ())
			if response.timestamp == self.ManifestTimestamp then
				Carrier.Log ("Package manifest is up to date (" .. self.ManifestTimestamp .. ").")
				return true
			end
			
			Carrier.Log ("Updating manifest " .. self.ManifestTimestamp .. " to " .. response.timestamp .. "...")
			self.ManifestTimestamp = response.timestamp
			local bootstrapSignature = file.Read ("garrysmod.io/carrier/bootstrap.signature.dat", "DATA")
			if Base64.Decode (response.bootstrapSignature) ~= bootstrapSignature then
				Carrier.Log ("Updating bootstrap...")
				self:UpdateBootstrap ():Await ()
			end
			local packageReleaseSet = {}
			for packageName, packageInfo in pairs (response.packages) do
				local package = self:GetPackage (packageName) or Carrier.Package (packageName)
				package = package:FromJson (packageInfo)
				self:AddPackage (package)
				
				for packageReleaseVersion, packageReleaseInfo in pairs (packageInfo.releases) do
					local packageRelease = package:GetRelease (packageReleaseVersion) or Carrier.PackageRelease (packageName, packageReleaseVersion)
					packageRelease:SetDeprecated (false)
					packageReleaseSet [packageRelease] = true
					packageRelease = packageRelease:FromJson (packageReleaseInfo)
					package:AddRelease (packageRelease)
				end
			end
			for packageRelease, _ in pairs (packageReleaseSet) do
				for dependencyName, dependencyVersion in packageRelease:GetDependencyEnumerator () do
					local dependency = self:GetPackageRelease (dependencyName, dependencyVersion)
					if dependency then
						dependency:AddDependent (packageRelease:GetName (), packageRelease:GetVersion ())
					end
				end
			end
			for package in self:GetPackageEnumerator () do
				for packageRelease in package:GetReleaseEnumerator () do
					if not packageRelease:IsDeveloper () and
					   not packageReleaseSet [packageRelease] then
						packageRelease:SetDeprecated (true)
					end
				end
			end
			self:SaveMetadata ()
			
			return true
		end
	)
end

function self:UpdateBootstrap ()
	return Task.Run (
		function ()
			local response
			for i = 1, 5 do
				response = HTTP.Get ("https://garrysmod.io/api/packages/v1/bootstrap"):Await ()
				if response:IsSuccess () then break end
				
				if i ~= 5 then
					local delay = 1 * math.pow (2, i - 1)
					Carrier.Warning ("Failed to fetch from https://garrysmod.io/api/packages/v1/bootstrap, retrying in " .. delay .. " second(s)...")
					Async.Sleep (delay):await ()
				end
			end
			
			if not response:IsSuccess () then
				Carrier.Warning ("Failed to download bootstrap.")
				return false
			end
			
			local response = util.JSONToTable (response:GetContent ())
			if not response then
				Carrier.Warning ("Invalid bootstrap response.")
				return false
			end
			
			file.Write ("garrysmod.io/carrier/bootstrap.dat", Base64.Decode (response.package))
			file.Write ("garrysmod.io/carrier/bootstrap.signature.dat", Base64.Decode (response.signature))
		end
	)
end

function self:UpdateLocalDeveloperPackages ()
	local pathId = CLIENT and "LCL" or "LSV"
	local files, folders = file.Find ("carrier/packages/*", pathId)
	
	local basePaths        = {}
	local constructorPaths = {}
	local destructorPaths  = {}
	for _, v in ipairs (files) do
		basePaths        [#basePaths + 1] = "carrier/packages/" .. v
		constructorPaths [#basePaths]     = "carrier/packages/" .. v
		destructorPaths  [#basePaths]     = nil
	end
	for _, v in ipairs (folders) do
		basePaths        [#basePaths + 1] = "carrier/packages/" .. v
		constructorPaths [#basePaths]     = "carrier/packages/" .. v .. "/_ctor.lua"
		destructorPaths  [#basePaths]     = "carrier/packages/" .. v .. "/_dtor.lua"
	end
	
	local dependencies = {}
	local replacements = {}
	for i = 1, #basePaths do
		local packageRelease, dependencySet, previousPackageRelease = self:UpdateLocalDeveloperPackage (basePaths [i], constructorPaths [i], destructorPaths [i], pathId)
		if packageRelease then
			dependencies [packageRelease] = dependencySet
			replacements [packageRelease] = previousPackageRelease
		end
	end
	for packageRelease, previousPackageRelease in pairs (replacements) do
		for dependentName, dependentVersion in previousPackageRelease:GetDependentEnumerator () do
			local dependent = self:GetPackageRelease (dependentName, dependentVersion)
			if dependent then
				dependent:RemoveDependency (previousPackageRelease:GetName (), previousPackageRelease:GetVersion ())
				dependent:AddDependency (packageRelease:GetName (), packageRelease:GetVersion ())
			end
		end
		for dependencyName, dependencyVersion in previousPackageRelease:GetDependencyEnumerator () do
			local dependency = self:GetPackageRelease (dependencyName, dependencyVersion)
			if dependency then
				dependent:RemoveDependent (previousPackageRelease:GetName (), previousPackageRelease:GetVersion ())
			end
		end
	end
	for packageRelease, dependencySet in pairs (dependencies) do
		for dependencyName, _ in pairs (dependencySet) do
			local dependencyPackage = self:GetPackage (dependencyName)
			local dependency = dependencyPackage and dependencyPackage:GetLocalDeveloperRelease ()
			if dependency then
				packageRelease:AddDependency (dependencyName, dependency:GetVersion ())
				dependency:AddDependent (packageRelease:GetName (), packageRelease:GetVersion ())
			end
		end
	end
end
function self:AddPackage (package)
	if self.Packages [package:GetName ()] then return end
	
	self.Packages [package:GetName ()] = package
	self.PackageCount = self.PackageCount + 1
end

function self:GetLoadRoots (path, loadRoots)
	local loadRoots = loadRoots or {}
	
	local autoloadSet = {}
	autoloadSet = Array.ToSet (file.Find (path .. "*.lua", "LUA"), autoloadSet)
	if SERVER then
		autoloadSet = Array.ToSet (file.Find (path .. "*.lua", "LSV"), autoloadSet)
	end
	if CLIENT and sv_allowcslua:GetBool () then
		autoloadSet = Array.ToSet (file.Find (path .. "*.lua", "LCL"), autoloadSet)
	end
	
	for autoload in pairs (autoloadSet) do
		local f = CompileFile (path .. autoload)
		if f then
			setfenv (f, {})
			
			for _, packageName in ipairs ({ f () }) do
				loadRoots [packageName] = true
			end
		end
	end
	
	return loadRoots
end

function self:ParsePackageConstructor (constructorPath, pathId)
	local code = file.Read (constructorPath, pathId)
	if not code then return nil, nil end
	local packageName = string.match (code, "%-%-%s*PACKAGE%s*([^%s]+)")
	if not packageName then return nil, nil end
	local dependencySet = {}
	for require, packageName in string.gmatch (code, "(require_?p?r?o?v?i?d?e?r?)%s*%(?[\"']([^\"]-)[\"']%)?") do
		if require == "require" then
			dependencySet [packageName] = true
		elseif require == "require_provider" then
			dependencySet [packageName .. ".GarrysMod"] = true
		end
	end
	
	return packageName, dependencySet
end

function self:UpdateLocalDeveloperPackage (basePath, constructorPath, destructorPath, pathId)
	local packageName, dependencySet = self:ParsePackageConstructor (constructorPath, pathId)
	if not packageName then return nil, nil end
	
	local package = self:GetPackage (packageName)
	if not package then
		package = Carrier.Package (packageName)
		self:AddPackage (package)
	end
	
	local destructorExists = destructorPath and file.Exists (destructorPath, pathId) or false
	local packageRelease = Carrier.LocalDeveloperPackageRelease (packageName, basePath, constructorPath, destructorExists and destructorPath or nil, pathId)
	local previousPackageRelease = package:GetLocalDeveloperRelease ()
	package:RemoveRelease (previousPackageRelease)
	package:AddRelease (packageRelease)
	
	return packageRelease, dependencySet, previousPackageRelease
end

local self = {}
Carrier.Package = Class (self, ISerializable)

function Carrier.Package.FromJson (info)
	local name = info.name
	local package = Carrier.Package (name)
	return package:FromJson (info)
end

function self:ctor (name)
	self.Name                  = name
	
	self.LocalDeveloperRelease = nil
	self.Releases              = {}
	self.ReleaseCount          = 0
	self.DeveloperReleaseCount = 0
	
	self.Loaded                = false
	self.LoadedRelease         = nil
	self.LoadEnvironment       = nil
	self.LoadExports           = nil
	self.LoadDestructor        = nil
end
function self:Serialize (streamWriter)
	streamWriter:UInt32 (self.ReleaseCount - self.DeveloperReleaseCount)
	for packageRelease in self:GetReleaseEnumerator () do
		if not packageRelease:IsDeveloper () then
			streamWriter:StringN8 (packageRelease:GetVersion ())
			packageRelease:Serialize (streamWriter)
		end
	end
end

function self:Deserialize (streamReader)
	local releaseCount = streamReader:UInt32 ()
	for i = 1, releaseCount do
		local packageReleaseVersion = streamReader:StringN8 ()
		local packageRelease = self:GetRelease (packageReleaseVersion) or Carrier.PackageRelease (self.Name, packageReleaseVersion)
		packageRelease:Deserialize (streamReader)
		self:AddRelease (packageRelease)
	end
end
function self:GetName ()
	return self.Name
end

function self:AddRelease (packageRelease)
	if self.Releases [packageRelease:GetVersion ()] then return end
	
	self.Releases [packageRelease:GetVersion ()] = packageRelease
	self.ReleaseCount = self.ReleaseCount + 1
	if packageRelease:IsDeveloper () then
		self.DeveloperReleaseCount = self.DeveloperReleaseCount + 1
		if packageRelease:IsLocal () then
			self.LocalDeveloperRelease = packageRelease
		end
	end
end

function self:RemoveRelease (packageRelease)
	if not packageRelease then return end
	local packageReleaseVersion = type (packageRelease) == "string" and packageRelease or packageRelease:GetVersion ()
	
	local packageRelease = self.Releases [packageReleaseVersion]
	if not packageRelease then return end
	
	self.Releases [packageReleaseVersion] = nil
	self.ReleaseCount = self.ReleaseCount - 1
	if packageRelease:IsDeveloper () then
		self.DeveloperReleaseCount = self.DeveloperReleaseCount - 1
		if self.LocalDeveloperRelease == packageRelease then
			self.LocalDeveloperRelease = nil
		end
	end
end

function self:GetLatestRelease ()
	local latestPackageRelease = nil
	for packageRelease in self:GetReleaseEnumerator () do
		if not packageRelease:IsDeveloper () and
		   not packageRelease:IsDeprecated () then
			if not latestPackageRelease or
			   latestPackageRelease:GetTimestamp () < packageRelease:GetTimestamp () then
				latestPackageRelease = packageRelease
			end
		end
	end
	return latestPackageRelease
end

function self:GetLocalDeveloperRelease ()
	return self.LocalDeveloperRelease
end

function self:GetRelease (packageReleaseVersion)
	return self.Releases [packageReleaseVersion]
end

function self:GetReleaseCount ()
	return self.ReleaseCount
end

function self:GetReleaseEnumerator ()
	return ValueEnumerator (self.Releases)
end
function self:Assimilate (packageRelease, environment, exports, destructor)
	self.Loaded          = true
	self.LoadedRelease   = packageRelease
	self.LoadEnvironment = environment
	self.LoadExports     = exports
	self.LoadDestructor  = destructor
	
	Carrier.Debug ("Assimilated package " .. self.Name .. ".")
end

function self:AssimilateInto (package)
	if not self:IsLoaded () then return end
	
	local packageRelease = package:GetRelease (self:GetLoadedRelease ():GetVersion ())
	if not packageRelease then
		Carrier.Warning ("Cannot transfer package " .. self.Name .. ", since release " .. self:GetLoadedRelease ():GetVersion () .. " is missing from new package system.")
	end
	package:Assimilate (packageRelease, self.LoadEnvironment, self.LoadExports, self.LoadDestructor)
end

function self:GetLoadedRelease ()
	return self.LoadedRelease
end

function self:IsLoaded ()
	return self.Loaded
end

function self:Load (packageReleaseVersion)
	if self.Loaded then return self.LoadExports end
	
	local t0 = Clock ()
	local packageRelease = self:GetRelease (packageReleaseVersion)
	if not packageRelease then
		Carrier.Warning ("Load: " .. self.Name .. " " .. packageReleaseVersion .. " not found!")
		return nil
	end
	
	self.Loaded = true
	self.LoadedRelease = packageRelease
	self.LoadEnvironment = {}
	self.LoadEnvironment._ENV = self.LoadEnvironment
	setmetatable (self.LoadEnvironment, { __index = getfenv () })
	self.LoadEnvironment.require = function (packageName)
		return Carrier.Packages:Load (packageName)
	end
	self.LoadEnvironment.require_provider = function (packageName)
		return Carrier.Packages:LoadProvider (packageName)
	end
	self.LoadEnvironment.include = function (path)
		local f = self.LoadEnvironment.loadfile (path)
		if not f then return end
		return f ()
	end
	
	self.LoadExports, self.LoadDestructor = packageRelease:Load (self.LoadEnvironment)
	
	local dt = Clock () - t0
	Carrier.Log (string.format ("Load: %s %s took %.2f ms", self.Name, packageReleaseVersion, dt * 1000))
	
	return self.LoadExports
end

function self:Unload ()
	if not self.Loaded then return end
	
	Carrier.Log ("Unload: " .. self.Name)
	
	if self.LoadDestructor then
		local success, err = xpcall (self.LoadDestructor, debug.traceback)
		if not success then Carrier.Warning (err) end
	end
	
	self.Loaded          = false
	self.LoadedRelease   = nil
	self.LoadEnvironment = nil
	self.LoadExports     = nil
	self.LoadDestructor  = nil
end

function self:FromJson (info)
	return self
end

local self = {}
Carrier.IPackageRelease = Interface (self)

function self:ctor (name)
	self.Name = name
	
	self.Dependencies    = {}
	self.DependencyCount = 0
	
	self.Dependents      = {}
	self.DependentCount  = 0
end

function self:GetName ()
	return self.Name
end

function self:GetVersion ()
	Error ("IPackageRelease:GetVersion : Not implemented.")
end

function self:GetTimestamp ()
	Error ("IPackageRelease:GetTimestamp : Not implemented.")
end

function self:IsDeprecated ()
	Error ("IPackageRelease:IsDeprecated : Not implemented.")
end

function self:IsDeveloper ()
	Error ("IPackageRelease:IsDeveloper : Not implemented.")
end
function self:AddDependency (name, version)
	if not self.Dependencies [name] then
		self.DependencyCount = self.DependencyCount + 1
	end
	self.Dependencies [name] = version
end

function self:GetDependencyCount ()
	return self.DependencyCount
end

function self:GetDependencyEnumerator ()
	return KeyValueEnumerator (self.Dependencies)
end

function self:RemoveDependency (name)
	if not self.Dependencies [name] then return end
	
	self.Dependencies [name] = nil
	self.DependencyCount = self.DependencyCount - 1
end
function self:AddDependent (name, version)
	if not self.Dependents [name] then
		self.DependentCount = self.DependentCount + 1
	end
	self.Dependents [name] = version
end

function self:GetDependentCount ()
	return self.DependentCount
end

function self:GetDependentEnumerator ()
	return KeyValueEnumerator (self.Dependents)
end

function self:RemoveDependent (name)
	if not self.Dependents [name] then return end
	
	self.Dependents [name] = nil
	self.DependentCount = self.DependentCount - 1
end
function self:IsAvailable ()
	Error ("IPackageRelease:IsAvailable : Not implemented.")
end

function self:Load (environment)
	Error ("IPackageRelease:Load : Not implemented.")
end

local self = {}
Carrier.PackageRelease = Class (self, Carrier.IPackageRelease, ISerializable)

function Carrier.PackageRelease.FromJson (info, name)
	local version = info.version
	local packageRelease = Carrier.PackageRelease (name, version)
	return packageRelease:FromJson (info)
end

function self:ctor (name, version)
	self.Version    = version
	self.Timestamp  = 0
	
	self.Deprecated = false
	
	self.Size       = 0
	self.FileName   = nil
end
function self:Serialize (streamWriter)
	streamWriter:UInt64  (self.Timestamp)
	streamWriter:Boolean (self.Deprecated)
	streamWriter:UInt64  (self.Size)
	
	streamWriter:UInt32 (self.DependencyCount)
	for dependencyName, dependencyVersion in self:GetDependencyEnumerator () do
		streamWriter:StringN8 (dependencyName)
		streamWriter:StringN8 (dependencyVersion)
	end
end

function self:Deserialize (streamReader)
	self.Timestamp  = streamReader:UInt64  ()
	self.Deprecated = streamReader:Boolean ()
	self.Size       = streamReader:UInt64  ()
	
	local dependencyCount = streamReader:UInt32 ()
	for i = 1, dependencyCount do
		local dependencyName    = streamReader:StringN8 ()
		local dependencyVersion = streamReader:StringN8 ()
		self:AddDependency (dependencyName, dependencyVersion)
	end
	
	self:UpdateFileName ()
end
function self:GetVersion ()
	return self.Version
end

function self:GetTimestamp ()
	return self.Timestamp
end

function self:IsDeprecated ()
	return self.Deprecated
end

function self:IsDeveloper ()
	return false
end
function self:IsAvailable ()
	return file.Exists (Carrier.Packages.CacheDirectory .. "/" .. self.FileName, "DATA")
end

function self:Load (environment)
	local inputStream = IO.FileInputStream.FromPath (Carrier.Packages.CacheDirectory .. "/" .. self.FileName, "DATA")
	if not inputStream then
		Carrier.Warning ("Package file for " .. self.Name .. " " .. self.Version .. " missing!")
		return
	end
	
	local packageFile = PackageFile.Deserialize (inputStream, PublicKey.Exponent, PublicKey.Modulus)
	inputStream:Close ()
	
	if packageFile:GetName () ~= self.Name or
	   packageFile:GetVersion () ~= self.Version then
		Carrier.Warning ("Package file for " .. self.Name .. " " .. self.Version .. " has incorrect name or version (" .. packageFile:GetName () .. " " .. packageFile:GetVersion () .. ")!")
		file.Delete (Carrier.Packages.CacheDirectory .. "/" .. self.FileName)
		return
	end
	
	if not packageFile:GetSection ("code") then
		Carrier.Warning ("Package file " .. self.Name .. " " .. self.Version .. " has no code section!")
		return
	elseif not packageFile:GetSection ("code"):IsVerified () then
		Carrier.Warning ("Package file " .. self.Name .. " " .. self.Version .. " has invalid signature for code section!")
		return
	elseif not packageFile:GetSection ("luahashes") then
		Carrier.Warning ("Package file " .. self.Name .. " " .. self.Version .. " has no Lua hashes section!")
		return
	elseif not packageFile:GetSection ("luahashes"):IsVerified () then
		Carrier.Warning ("Package file " .. self.Name .. " " .. self.Version .. " has invalid signature for Lua hashes section!")
		return
	end
	
	local codeSection = packageFile:GetSection ("code")
	environment.loadfile = function (path)
		local file = codeSection:GetFile (path)
		if not file then
			Carrier.Warning (self.Name .. " " .. self.Version .. ": " .. path .. " not found.")
			return nil, nil
		end
		
		local f = CompileString (file:GetData (), string.lower (self.Name) .. "/" .. path, false)
		
		if type (f) == "string" then
			Carrier.Warning (self.Name .. " " .. self.Version .. ": " .. f)
			return nil, nil
		end
		
		setfenv (f, environment)
		return f
	end
	local f = environment.loadfile ("_ctor.lua")
	if not f then
		environment.loadfile = nil
		environment.include  = nil
		return nil, nil
	end
	local file = codeSection:GetFile ("_dtor.lua")
	local destructor = file and environment.loadfile ("_dtor.lua")
	
	local success, exports = xpcall (f, debug.traceback)
	environment.loadfile = nil
	environment.include  = nil
	if not success then
		Carrier.Warning (exports)
		return nil, destructor
	end
	
	return exports, destructor
end
function self:GetSize ()
	return self.Size
end

function self:GetFileName ()
	return self.FileName
end

function self:SetDeprecated (deprecated)
	self.Deprecated = deprecated
end

function self:FromJson (info)
	self.Timestamp = info.timestamp
	self.Size      = info.size
	
	for dependencyName, dependencyVersion in pairs (info.dependencies) do
		self:AddDependency (dependencyName, dependencyVersion)
	end
	
	self:UpdateFileName ()
	
	return self
end
function self:UpdateFileName ()
	self.FileName = "release-" .. Carrier.ToFileName (self.Name) .. "-" .. string.format ("%08x", self.Timestamp) .. "-" .. Carrier.ToFileName (self.Version) .. ".dat"
end

local self = {}
Carrier.LocalDeveloperPackageRelease = Class (self, Carrier.IPackageRelease)

function self:ctor (name, basePath, constructorPath, destructorPath, pathId)
	self.Timestamp       = file.Time (basePath, pathId)
	self.Version         = "dev-local-" .. string.format ("%08x", self.Timestamp)
	
	self.FileName        = "dev-local-" .. Carrier.ToFileName (self.Name) .. "-" .. string.format ("%08x", self.Timestamp) .. ".dat"
	
	self.PathId          = pathId
	self.BasePath        = basePath
	self.ConstructorPath = constructorPath
	self.DestructorPath  = destructorPath
end
function self:GetVersion ()
	return self.Version
end

function self:GetTimestamp ()
	return self.Timestamp
end

function self:IsDeprecated ()
	return false
end

function self:IsDeveloper ()
	return true
end
function self:IsAvailable ()
	return true
end

function self:Load (environment)
	environment.loadfile = function (path)
		path = self.BasePath .. "/" .. path
		
		local f = CompileFile (path)
		
		if not f then
			Carrier.Warning (path .. " not found or has syntax error.")
			return nil, nil
		end
		
		setfenv (f, environment)
		return f
	end
	local f = CompileFile (self.ConstructorPath)
	if not f then
		Carrier.Warning (self.ConstructorPath .. " not found or has syntax error.")
		return nil, nil
	end
	
	setfenv (f, environment)
	local destructor = self.DestructorPath and CompileFile (self.DestructorPath)
	if destructor then
		setfenv (destructor, environment)
	end
	
	local success, exports = xpcall (f, debug.traceback)
	if not success then
		Carrier.Warning (exports)
		return nil, destructor
	end
	
	return exports, destructor
end
function self:IsLocal ()
	return true
end

function self:IsRemote ()
	return false
end

local self = {}
Carrier.RemoteDeveloperPackageRelease = Class (self, Carrier.IPackageRelease)

function self:ctor (name, timestamp)
	self.Version   = "dev-remote-" .. string.format ("%08x", timestamp)
	self.Timestamp = timestamp
	
	self.Size      = nil
	self.FileName  = "dev-remote-" .. Carrier.ToFileName (self.Name) .. "-" .. string.format ("%08x", self.Timestamp) .. ".dat"
end
function self:GetVersion ()
	return self.Version
end

function self:GetTimestamp ()
	return self.Timestamp
end

function self:IsDeprecated ()
	return false
end

function self:IsDeveloper ()
	return true
end
function self:IsLocal ()
	return false
end

function self:IsRemote ()
	return true
end

function self:GetSize ()
	return self
end


Carrier.Packages = Carrier.Packages ()

local function WithJIT (f, ...)
	local hook = { debug.gethook () }
	debug.sethook ()
	return (
		function (...)
			debug.sethook (unpack (hook))
			return ...
		end
	) (f (...))
end

return Task.Run (
	function ()
		if _G.Carrier and
		   type (_G.Carrier.Uninitialize) == "function" then
			_G.Carrier.Uninitialize ()
		end
		
		local carrier = nil
		local developerRelease = Carrier.Packages:GetLocalDeveloperRelease ("Carrier")
		if Carrier.Packages:IsLocalDeveloperEnabled () and developerRelease then
			carrier = Carrier.Packages:Load ("Carrier", developerRelease:GetVersion ())
		else
			Carrier.Packages:LoadMetadata ()
			local downloadRequired = Carrier.Packages:IsPackageReleaseAvailableRecursive ("Carrier")
			
			if downloadRequired then
				Carrier.Packages:Update ():Await ()
				Carrier.Packages:DownloadRecursive ("Carrier")
			end
			
			carrier = WithJIT (Carrier.Packages.Load, Carrier.Packages, "Carrier")
			
			-- Update and retry on failure
			if not carrier and not downloadRequired then
				Carrier.Packages:Update ():Await ()
				Carrier.Packages:DownloadRecursive ("Carrier")
				carrier = WithJIT (Carrier.Packages.Load, Carrier.Packages, "Carrier")
			end
		end
		
		if not carrier then return false end
		
		-- Load package listing
		carrier.Packages:LoadMetadata ()
		
		-- Assimilate existing packages
		for packageName, bootstrapPackage in pairs (Carrier.Packages.LoadedPackages) do
			local package = carrier.Packages:GetPackage (packageName)
			bootstrapPackage:AssimilateInto (package)
		end
		
		-- Initialize
		carrier.Packages:Initialize ()
		
		_G.Carrier = _G.Carrier or {}
		_G.Carrier.Uninitialize = function () carrier.Packages:Uninitialize () end
		_G.Carrier.Require = function (packageName) return carrier.Packages:Load (packageName) end
		_G.Carrier.require = _G.Carrier.Require
		
		return true
	end
)

-- END CARRIER BOOTSTRAP
