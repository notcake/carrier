-- PACKAGE Eka.AST

AST = {}

Error = require ("Pylon.Error")

require ("Pylon.OOP").Initialize (_ENV)
require ("Pylon.Enumeration").Initialize (_ENV)

include ("node.lua")
include ("comment.lua")
include ("identifier.lua")
include ("label.lua")

include ("statements/statement.lua")
include ("statements/block.lua")
include ("statements/if.lua")
include ("statements/break.lua")
include ("statements/continue.lua")
include ("statements/goto.lua")

include ("statements/variabledeclaration.lua")

include ("expressions/expression.lua")
include ("expressions/phiexpression.lua")
include ("expressions/binaryexpression.lua")
include ("expressions/unaryexpression.lua")
include ("expressions/literal.lua")

include ("operators/associativity.lua")
include ("operators/precedence.lua")
include ("operators/ioperator.lua")
include ("operators/ibinaryoperator.lua")
include ("operators/binaryoperator.lua")
include ("operators/iunaryoperator.lua")
include ("operators/unaryoperator.lua")
include ("operators/leftunaryoperator.lua")
include ("operators/rightunaryoperator.lua")

return AST
