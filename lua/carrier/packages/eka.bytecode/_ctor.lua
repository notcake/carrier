-- PACKAGE Eka.Bytecode

Bytecode = {}

Error = require("Pylon.Error")

require("Pylon.OOP").Initialize(_ENV)
require("Pylon.Enumeration").Initialize(_ENV)

include("branchtype.lua")
include("iopcodeinfo.lua")
include("iopcodereader.lua")

return Bytecode
