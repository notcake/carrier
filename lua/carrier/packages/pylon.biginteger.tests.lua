-- PACKAGE Pylon.BigInteger.Tests

local BigInteger = require("Pylon.BigInteger")

return function()
	-- Conversions
	assert(BigInteger.FromUInt32(0x00000000):ToUInt32() == 0x00000000)
	assert(BigInteger.FromUInt32(0x00000001):ToUInt32() == 0x00000001)
	assert(BigInteger.FromUInt32(0x00FFFFFF):ToUInt32() == 0x00FFFFFF)
	assert(BigInteger.FromUInt32(0x01FFFFFE):ToUInt32() == 0x01FFFFFE)
	assert(BigInteger.FromUInt32(0x01FFFFFF):ToUInt32() == 0x01FFFFFF)
	assert(BigInteger.FromUInt32(0xFFFFFFFF):ToUInt32() == 0xFFFFFFFF)
	
	assert(BigInteger.FromDouble( 0):ToDouble() ==  0)
	assert(BigInteger.FromDouble( 1):ToDouble() ==  1)
	assert(BigInteger.FromDouble(-1):ToDouble() == -1)
	assert(BigInteger.FromDouble( 0x00FFFFFF):ToDouble() ==  0x00FFFFFF)
	assert(BigInteger.FromDouble(-0x00FFFFFF):ToDouble() == -0x00FFFFFF)
	assert(BigInteger.FromDouble( 0x01FFFFFF):ToDouble() ==  0x01FFFFFF)
	assert(BigInteger.FromDouble(-0x01FFFFFF):ToDouble() == -0x01FFFFFF)
	assert(BigInteger.FromDouble( 39482395789445):ToDouble() ==  39482395789445)
	assert(BigInteger.FromDouble(-39482395789445):ToDouble() == -39482395789445)
	
	assert(BigInteger.FromDecimal(""):ToDecimal()  == "0")
	assert(BigInteger.FromDecimal("0"):ToDecimal() == "0")
	assert(BigInteger.FromDecimal("-0"):ToDecimal() == "0")
	assert(BigInteger.FromDecimal("1"):ToDecimal()  == "1")
	assert(BigInteger.FromDecimal("-1"):ToDecimal() == "-1")
	assert(BigInteger.FromDecimal("123456789012345678901234567890"):ToDecimal()  == "123456789012345678901234567890")
	assert(BigInteger.FromDecimal("-123456789012345678901234567890"):ToDecimal() == "-123456789012345678901234567890")
	
	-- Subtraction
	assert(BigInteger.FromDouble(10) - BigInteger.FromDouble(12) == BigInteger.FromDouble(-2))
	
	-- Multiplication
	assert(BigInteger.FromHex("AAAAAABBBBBBCCCCCC") * BigInteger.FromHex("DDDDDD")       == BigInteger.FromHex("93E93E0ECA8641FDB8B4E81C"))
	assert(BigInteger.FromHex("AAAAAABBBBBBCCCCCC") * BigInteger.FromHex("DDDDDDEEEEEE") == BigInteger.FromHex("93E93EAE147A51EB845E6F80740DA8"))
	
	assert(BigInteger.FromDouble( 0x01FFFFFF) * BigInteger.FromDouble( 0x01FFFFFF) == BigInteger.FromHex("3FFFFFC000001"))
	assert(BigInteger.FromDouble(-0x01FFFFFF) * BigInteger.FromDouble(-0x01FFFFFF) == BigInteger.FromHex("3FFFFFC000001"))
	
	-- Squaring
	assert(BigInteger.FromDouble( 0x01FFFFFF):Square() == BigInteger.FromHex("3FFFFFC000001"))
	assert(BigInteger.FromDouble(-0x01FFFFFF):Square() == BigInteger.FromHex("3FFFFFC000001"))
	
	-- Root
	local success, root = BigInteger.FromUInt32(81):Root(2)
	assert(success)
	assert(root:ToUInt32() == 9)
	
	local success, root = BigInteger.FromUInt32(81):SquareRoot()
	assert(success)
	assert(root:ToUInt32() == 9)
	
	return true
end
