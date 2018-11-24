-- PACKAGE Aether

Aether = {}

Error = require ("Pylon.Error")
Lua   = require ("Pylon.Lua")

require ("Pylon.OOP").Initialize (_ENV)
require ("Pylon.Enumeration").Initialize (_ENV)

Async      = require_provider ("Pylon.Async")
Future     = require ("Pylon.Future")
Task       = require ("Pylon.Task")
String     = require ("Pylon.String")

Base64     = require ("Pylon.Base64")
BigInteger = require ("Pylon.BigInteger")
Crypto     = require ("Pylon.Crypto")

Asn1       = require ("Jotun.Asn1")

include ("api.lua")

Aether.Identity = {}
include ("identity/storage.lua")
include ("identity/api.lua")

include ("iserversession.lua")

Aether.AddressIP   = nil
Aether.AddressPort = nil
Aether.AddressFuture = Future ()

Aether.Session = nil

function Aether.GetSession ()
	return Aether.Session
end

Aether.SessionWaiters = {}
function Aether.WaitSession (f)
	Aether.SessionWaiters [f] = true
	
	if Aether.Session then
		f (Aether.Session)
	end
end

if SERVER then
	Aether.Identity.Storage.Initialize ()
	
	-- Resolve IP address
	Task.Run (
		function ()
			while not game.SinglePlayer () and
			      string.find (game.GetIPAddress (), "^0%.0%.0%.0:") do
				Async.WaitTick ():Await ()
			end
			
			Aether.AddressIP, Aether.AddressPort = string.match (game.GetIPAddress (), "([%d%.]+):(%d+)")
			Aether.AddressPort = tonumber (Aether.AddressPort)
			Aether.AddressFuture:Resolve (Aether.AddressIP, Aether.AddressPort)
		end
	)
	
	Task.Run (
		function ()
			Aether.AddressFuture:Await ()
			
			local id, privateKey = Aether.Identity.Storage.Load (Aether.AddressIP, Aether.AddressPort)
			
			-- Register server
			if not id then
				local success
				success, id, privateKey = Aether.Identity.API.Register (Aether.AddressIP, Aether.AddressPort, GetHostName ()):Await ()
				Aether.Identity.Storage.Save (Aether.AddressIP, Aether.AddressPort, id, privateKey)
			end
			
			-- Start session
			local success, sessionKey = Aether.Identity.API.Login (id, privateKey):Await ()
			
			Aether.Session = Aether.ServerSession (sessionKey)
			for f, _ in pairs (Aether.SessionWaiters) do
				f (Aether.Session)
			end
		end
	)
end

return Aether
