Analysis = {}

Error = require ("Pylon.Error")

require ("Pylon.OOP").Initialize (_ENV)
require ("Pylon.Enumeration").Initialize (_ENV)

Array = require ("Pylon.Array")

Bytecode = require ("Eka.Bytecode")

include ("controlflowgraph/controlflowgraph.lua")
include ("controlflowgraph/controlflowgraph.sequence.lua")
include ("controlflowgraph/controlflowgraph.link.lua")

include ("dataflow/dataflowgraph.lua")
include ("dataflow/dataflowgraph.node.lua")
include ("dataflow/dataflowgraph.externalnode.lua")
include ("dataflow/dataflowgraph.inputnode.lua")
include ("dataflow/dataflowgraph.outputnode.lua")

include ("dataflow/dataflowgraph.binaryoperatornode.lua")
include ("dataflow/dataflowgraph.unaryoperatornode.lua")
include ("dataflow/dataflowgraph.leftunaryoperatornode.lua")
include ("dataflow/dataflowgraph.rightunaryoperatornode.lua")

return Analysis
