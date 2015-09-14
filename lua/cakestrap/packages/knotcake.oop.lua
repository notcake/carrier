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

include ("knotcake.oop/class.lua")
-- OOP.Class1  = function<... -> OOP.Class2>

include ("knotcake.oop/object.lua")
include ("knotcake.oop/class.lua")
-- OOP.Object0 = OOP.Class2<OOP.Object0>
-- OOP.Class3  = OOP.Class2<OOP.Class3:OOP.Object0>

OOP.Class:Assimilate (OOP.Object)
OOP.Class:Assimilate (OOP.Class )
-- OOP.Object0 = OOP.Class3:OOP.Object0<OOP.Object0>
-- OOP.Class3  = OOP.Class3:OOP.Object0<OOP.Class3:OOP.Object0>

include ("knotcake.oop/enum.lua")

include ("knotcake.oop/icloneable.lua")
include ("knotcake.oop/event.lua")
include ("knotcake.oop/idisposable.lua")

function OOP.Initialize (destinationTable)
	destinationTable.Object = OOP.Object
	destinationTable.Class  = OOP.Class
	destinationTable.Enum   = OOP.Enum
end

return OOP