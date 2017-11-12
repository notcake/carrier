-- PACKAGE Pylon.Crypto

Crypto = {}

bit = require ("bit")

Error = require ("Pylon.Error")

OOP = require ("Pylon.OOP")
OOP.Initialize (_ENV)

include ("md5.lua")
include ("sha256.lua")

Crypto.AES = {}
include ("aes.sbox.lua")

include ("photon128.lua")

return Crypto
