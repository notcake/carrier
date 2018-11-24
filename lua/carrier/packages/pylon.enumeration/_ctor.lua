-- PACKAGE Pylon.Enumeration

Enumeration = {}

Error = require("Pylon.Error")

OOP = require("Pylon.OOP")
OOP.Initialize(_ENV)

CompactList = require("Pylon.Containers.CompactList")

include("ienumerator.lua")
include("ienumerable.lua")

include("ienumeratorextension.lua")

include("functionenumerator.lua")
include("enumerators.lua")

include("enumeratorfunctionextension.lua")

function Enumeration.Initialize(destinationTable)
	destinationTable.IEnumerator            = Enumeration.IEnumerator
	destinationTable.IEnumerable            = Enumeration.IEnumerable
	
	destinationTable.FunctionEnumerator     = Enumeration.FunctionEnumerator
	
	destinationTable.ArrayEnumerator        = Enumeration.ArrayEnumerator
	destinationTable.KeyEnumerator          = Enumeration.KeyEnumerator
	destinationTable.ValueEnumerator        = Enumeration.ValueEnumerator
	destinationTable.KeyValueEnumerator     = Enumeration.KeyValueEnumerator
	destinationTable.ValueKeyEnumerator     = Enumeration.ValueKeyEnumerator
	destinationTable.NullEnumerator         = Enumeration.NullEnumerator
	destinationTable.SingleValueEnumerator  = Enumeration.SingleValueEnumerator
	destinationTable.YieldEnumerator        = Enumeration.YieldEnumerator
	destinationTable.YieldEnumeratorFactory = Enumeration.YieldEnumeratorFactory
	
	return destinationTable
end

return Enumeration
