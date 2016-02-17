OOP = {}

OOP.Error      = CakeStrap.LoadPackage ("Knotcake.Error")
OOP.Algorithms = CakeStrap.LoadPackage ("Knotcake.Algorithms")
OOP.Table      = CakeStrap.LoadPackage ("Knotcake.Table")

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

include ("icloneable.lua")
include ("event.lua")
include ("property.lua")
include ("idisposable.lua")
include ("iserializable.lua")

function OOP.Initialize (destinationTable)
	destinationTable.Object        = OOP.Object
	destinationTable.Class         = OOP.Class
	destinationTable.Enum          = OOP.Enum
	destinationTable.Event         = OOP.Event
	destinationTable.Property      = OOP.Property
	
	destinationTable.IDisposable   = OOP.IDisposable
	destinationTable.ICloneable    = OOP.ICloneable
	destinationTable.ISerializable = OOP.ISerializable
end

return OOP
