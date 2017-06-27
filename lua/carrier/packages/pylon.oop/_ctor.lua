OOP = {}

Error      = require ("Pylon.Error")
Algorithms = require ("Pylon.Algorithms")

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
-- OOP.Class0  = function<method table -> function<... -> object>>

include ("class.lua")
-- OOP.Class1  = function<... -> OOP.Class2>

include ("object.lua")
include ("class.lua")
-- OOP.Object0 = OOP.Class2<OOP.Object0>
-- OOP.Class3  = OOP.Class2<OOP.Class3:OOP.Object0>

OOP.Class:Assimilate (OOP.Object)
OOP.Class:Assimilate (OOP.Class )
-- OOP.Object0 = OOP.Class3:OOP.Object0<OOP.Object0>
-- OOP.Class3  = OOP.Class3:OOP.Object0<OOP.Class3:OOP.Object0>

include ("enum.lua")
include ("flags.lua")

include ("icloneable.lua")
include ("event.lua")
include ("property.lua")
include ("idisposable.lua")
include ("iserializable.lua")
include ("iserializer.lua")

include ("serializableserializer.lua")
include ("serializerserializable.lua")

function OOP.WeakTable      () return setmetatable ({}, { __mode = "kv" }) end
function OOP.WeakKeyTable   () return setmetatable ({}, { __mode = "k"  }) end
function OOP.WeakValueTable () return setmetatable ({}, { __mode = "v"  }) end

function OOP.Initialize (destinationTable)
	destinationTable = destinationTable or {}
	
	destinationTable.Object         = OOP.Object
	destinationTable.Class          = OOP.Class
	destinationTable.Enum           = OOP.Enum
	destinationTable.Flags          = OOP.Flags
	destinationTable.Event          = OOP.Event
	destinationTable.Property       = OOP.Property
	
	destinationTable.IDisposable    = OOP.IDisposable
	destinationTable.ICloneable     = OOP.ICloneable
	destinationTable.ISerializable  = OOP.ISerializable
	destinationTable.ISerializer    = OOP.ISerializer
	
	destinationTable.WeakTable      = OOP.WeakTable
	destinationTable.WeakKeyTable   = OOP.WeakKeyTable
	destinationTable.WeakValueTable = OOP.WeakValueTable
	
	return destinationTable
end

return OOP
