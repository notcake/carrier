Analysis = {}

Error = require ("Pylon.Error")

require ("Pylon.OOP").Initialize (_ENV)
require ("Pylon.Enumeration").Initialize (_ENV)

Bytecode = require ("Eka.Bytecode")

include ("controlflowgraph/controlflowgraph.lua")
include ("controlflowgraph/controlflowgraph.sequence.lua")

include ("dataflowgraph/dataflowgraph.lua")
include ("dataflowgraph/dataflowgraph.node.lua")

return Analysis
