-- PACKAGE Eka.AST

AST = {}

Error = require ("Pylon.Error")

require ("Pylon.OOP").Initialize (_ENV)
require ("Pylon.Enumeration").Initialize (_ENV)

include ("node.lua")
include ("expression.lua")
include ("binaryexpression.lua")
include ("unaryexpression.lua")
include ("literal.lua")

include ("associativity.lua")
include ("precedence.lua")
include ("ioperator.lua")
include ("ibinaryoperator.lua")
include ("binaryoperator.lua")
include ("iunaryoperator.lua")
include ("unaryoperator.lua")
include ("leftunaryoperator.lua")
include ("rightunaryoperator.lua")

return AST
