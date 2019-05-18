-- PACKAGE Pylon.BigInteger.Tests

local BigInteger = require("Pylon.BigInteger")

return function()
	assert(BigInteger.FromUInt32(0x00FFFFFF):ToDecimal() == tostring(0x00FFFFFF))
	assert(BigInteger.FromUInt32(0x01FFFFFF):ToDecimal() == tostring(0x01FFFFFF))
	assert(BigInteger.FromUInt32(0x01FFFFFE):ToDecimal() == tostring(0x01FFFFFE))
	
	assert(BigInteger.FromDouble( 39482395789445):ToDecimal() == tostring( 39482395789445))
	assert(BigInteger.FromDouble(-39482395789445):ToDecimal() == tostring(-39482395789445))
	
	assert(BigInteger.FromDouble(10) - BigInteger.FromDouble(12) == BigInteger.FromDouble(-2))
	
	assert(BigInteger.FromHex("AAAAAABBBBBBCCCCCC") * BigInteger.FromHex("DDDDDD")       == BigInteger.FromHex("93E93E0ECA8641FDB8B4E81C"))
	assert(BigInteger.FromHex("AAAAAABBBBBBCCCCCC") * BigInteger.FromHex("DDDDDDEEEEEE") == BigInteger.FromHex("93E93EAE147A51EB845E6F80740DA8"))
	
	assert(BigInteger.FromDouble( 0x01FFFFFF) * BigInteger.FromDouble( 0x01FFFFFF) == BigInteger.FromHex("3FFFFFC000001"))
	assert(BigInteger.FromDouble(-0x01FFFFFF) * BigInteger.FromDouble(-0x01FFFFFF) == BigInteger.FromHex("3FFFFFC000001"))
	
	return true
end
