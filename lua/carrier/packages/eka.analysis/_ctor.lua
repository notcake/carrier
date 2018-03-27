-- PACKAGE Eka.Analysis

Analysis = {}

Error = require ("Pylon.Error")

require ("Pylon.OOP").Initialize (_ENV)
require ("Pylon.Enumeration").Initialize (_ENV)

Array = require ("Pylon.Array")
Map   = require ("Pylon.Map")

AST      = require ("Eka.AST")
Bytecode = require ("Eka.Bytecode")

include ("controlflowgraph/controlflowgraph.lua")
include ("controlflowgraph/controlflowgraph.block.lua")
include ("controlflowgraph/controlflowgraph.ilink.lua")
include ("controlflowgraph/controlflowgraph.link.lua")

include ("dataflow/dataflowgraph.lua")

return Analysis
