local BigInteger = require ("Pylon.BigInteger")

return function ()
	assert (BigInteger.FromUInt32 (0x00FFFFFF):ToDecimal () == tostring (0x00FFFFFF))
	assert (BigInteger.FromUInt32 (0x01FFFFFF):ToDecimal () == tostring (0x01FFFFFF))
	assert (BigInteger.FromUInt32 (0x01FFFFFE):ToDecimal () == tostring (0x01FFFFFE))
	
	assert (BigInteger.FromDouble ( 39482395789445):ToDecimal () == tostring ( 39482395789445))
	assert (BigInteger.FromDouble (-39482395789445):ToDecimal () == tostring (-39482395789445))
	
	assert (BigInteger.FromDouble (10) - BigInteger.FromDouble (12) == BigInteger.FromDouble (-2))
	
	return true
end
