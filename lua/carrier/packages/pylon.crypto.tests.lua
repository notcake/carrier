local Crypto = require ("Pylon.Crypto")

return function ()
	assert (Crypto.SHA256 ():Finish () == "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")
	assert (Crypto.SHA256 ():Update ("\xd3"):Finish () == "28969cdfa74a12c82f3bad960b0b000aca2ac329deea5c2328ebc6f2ba9802c1")
	assert (Crypto.SHA256 ():Update ("\x11\xaf"):Finish () == "5ca7133fa735326081558ac312c620eeca9970d1e70a4b95533d956f072d1f98")
end
