OOP = {}

OOP.Error = CakeStrap.LoadPackage ("Knotcake.Error")
OOP.Table = CakeStrap.LoadPackage ("Knotcake.Table")

include ("knotcake.oop/class.lua")
include ("knotcake.oop/enum.lua")

function OOP.Initialize (destinationTable)
	destinationTable.Class = OOP.Class
end

return OOP