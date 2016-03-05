Enumeration = {}

OOP = CakeStrap.LoadPackage ("Knotcake.OOP")
OOP.Initialize (_ENV)

include ("ienumerator.lua")
include ("ienumerable.lua")

include ("ienumeratorextension.lua")

include ("functionenumerator.lua")
include ("enumerators.lua")

include ("enumeratorfunctionextension.lua")

function Enumeration.Initialize (destinationTable)
	destinationTable.IEnumerator            = Enumeration.IEnumerator
	destinationTable.IEnumerable            = Enumeration.IEnumerable
	
	destinationTable.FunctionEnumerator     = Enumeration.FunctionEnumerator
	
	destinationTable.ArrayEnumerator        = Enumeration.ValueEnumerator
	destinationTable.KeyEnumerator          = Enumeration.ValueEnumerator
	destinationTable.ValueEnumerator        = Enumeration.ValueEnumerator
	destinationTable.KeyValueEnumerator     = Enumeration.ValueEnumerator
	destinationTable.ValueKeyEnumerator     = Enumeration.ValueEnumerator
	destinationTable.NullEnumerator         = Enumeration.ValueEnumerator
	destinationTable.SingleValueEnumerator  = Enumeration.ValueEnumerator
	destinationTable.YieldEnumerator        = Enumeration.ValueEnumerator
	destinationTable.YieldEnumeratorFactory = Enumeration.ValueEnumerator
	
	return destinationTable
end

return Enumeration
