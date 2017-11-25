-- PACKAGE Carrier.PublicKey

local PublicKey = {}

local Base64     = require ("Pylon.Base64")
local BigInteger = require ("Pylon.BigInteger")
local IO         = require ("Pylon.IO")

PublicKey.Raw = [[
---- BEGIN SSH2 PUBLIC KEY ----
Comment: "packages.garrysmod.io"
AAAAB3NzaC1yc2EAAAABJQAAAIEAlwd31/n5mkgP0Mgf2EUncxaX7bo8NwZW6Eqt
g8l/R8Ir9fCrQ73QnJsg2UpEBQ2PySVpZqNmUsCOCCTT/Gz11PC19qA8+6VORan+
ifa9gci12J1eJd30uWAji1pTRl6vnYWKtsYoP5i0IYbGb6RKALjKmUxNjvHJA12S
tyj4iB0=
---- END SSH2 PUBLIC KEY ----
]]

local base64 = string.match (PublicKey.Raw, "^%-%-[^\n]*\nComment:[^\n]+\n([A-Za-z0-9%+/%s]+=?=?)\n%-%-.*$")

local inputStream = IO.StringInputStream (Base64.Decode (base64))
inputStream:Bytes (inputStream:UInt32BE ())
PublicKey.Exponent = BigInteger.FromBlob (inputStream:Bytes (inputStream:UInt32BE ()))
PublicKey.Modulus  = BigInteger.FromBlob (inputStream:Bytes (inputStream:UInt32BE ()))
inputStream:Close ()

return PublicKey
