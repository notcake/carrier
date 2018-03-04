-- PACKAGE Pylon.Socket.Tests

local Socket = require ("Pylon.Socket")

return function ()
	local s = Socket.Tcp.Connect ("google.com", 80)
	s:Send ("GET / HTTP/1.1\n")
	s:Send ("Host: google.com\n")
	s:Send ("\n")
	print (s:Receive ())
end
