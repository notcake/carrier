-- PACKAGE Panopticon.Verification

Verification = {}

bit        = require_provider ("bit")
jit_util   = require_provider ("jit.util")

loadstring = require_provider ("loadstring")

Error = require ("Pylon.Error")

require ("Pylon.OOP").Initialize (_ENV)
require ("Pylon.Enumeration").Initialize (_ENV)
IO = require ("Pylon.IO")

ICollection = require ("Pylon.Containers.ICollection")

String = require ("Pylon.String")
ULEB128 = require ("Pylon.ULEB128")

CRC32  = require_provider ("Pylon.CRC32")
Crypto = require ("Pylon.Crypto")

include ("bytecode.lua")

include ("luafile.lua")

return Verification
