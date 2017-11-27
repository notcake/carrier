-- Hand-crafted code preloader, computer-generated with ❤

-- Artisanal prime numbers, do not steal
-- EVAL "local publicKeyExponent = \"" .. require ("Carrier.PublicKey").Exponent:ToDecimal () .. "\""
-- EVAL "local publicKeyModulus  = \"" .. require ("Carrier.PublicKey").Modulus :ToDecimal () .. "\""

local OOP = {}
-- SED Pylon.OOP /function OOP%.Class.-\nend/
local function Class (methodTable)
	return setmetatable ({}, { __call = OOP.Class (methodTable) })
end

-- TODO: better crypto
local Crypto = {}
-- INCLUDE carrier/packages/pylon.crypto/sha256.lua

local Base64 = {}
-- SED Pylon.Base64 /local math_floor.-\nend.-\nend*/

local String = {}
-- SED Pylon.String /local string_char[^\r\n]*/
-- SED Pylon.String /local string_gmatch[^\r\n]*/
-- SED Pylon.String /local table_concat[^\r\n]*/
-- SED Pylon.String /local hexMap.-\nend/
-- SED Pylon.String /function String%.FromHex.-\nend/

local UInt24 = {}
-- SED Pylon.UInt24 /local bit_band[^\r\n]*/
-- SED Pylon.UInt24 /local math_floor[^\r\n]*/
-- SED Pylon.UInt24 /local math_log[^\r\n]*/
-- SED Pylon.UInt24 /local math_max[^\r\n]*/
-- SED Pylon.UInt24 /UInt24.Zero[^\r\n]*/
-- SED Pylon.UInt24 /UInt24.Maximum[^\r\n]*/
-- SED Pylon.UInt24 /UInt24.BitCount[^\r\n]*/
-- SED Pylon.UInt24 /function UInt24%.Add.-\nend/
-- SED Pylon.UInt24 /function UInt24%.AddWithCarry.-\nend/
-- SED Pylon.UInt24 /function UInt24%.MultiplyAdd2.-\nend/
-- SED Pylon.UInt24 /function UInt24%.Subtract.-\nend/
-- SED Pylon.UInt24 /function UInt24%.SubtractWithBorrow.-\nend/
-- SED Pylon.UInt24 /local k[^\r\n]*/
-- SED Pylon.UInt24 /function UInt24%.CountLeadingZeros.-\nend/

local self = {}
local BigInteger = Class (self)
-- SED Pylon.BigInteger /local tonumber[^\r\n]*/
-- SED Pylon.BigInteger /local bit_band[^\r\n]*/
-- SED Pylon.BigInteger /local bit_rshift[^\r\n]*/
-- SED Pylon.BigInteger /local math_floor[^\r\n]*/
-- SED Pylon.BigInteger /local math_max[^\r\n]*/
-- SED Pylon.BigInteger /local string_byte[^\r\n]*/
-- SED Pylon.BigInteger /local string_sub[^\r\n]*/
-- SED Pylon.BigInteger /local table_concat[^\r\n]*/
-- SED Pylon.BigInteger /local UInt24_Zero[^\r\n]*/
-- SED Pylon.BigInteger /local UInt24_Maximum[^\r\n]*/
-- SED Pylon.BigInteger /local UInt24_BitCount[^\r\n]*/
-- SED Pylon.BigInteger /local UInt24_Add[^\r\n]*/
-- SED Pylon.BigInteger /local UInt24_AddWithCarry[^\r\n]*/
-- SED Pylon.BigInteger /local UInt24_MultiplyAdd2[^\r\n]*/
-- SED Pylon.BigInteger /local UInt24_Subtract[^\r\n]*/
-- SED Pylon.BigInteger /local UInt24_SubtractWithBorrow[^\r\n]*/
-- SED Pylon.BigInteger /local UInt24_CountLeadingZeros[^\r\n]*/
-- SED Pylon.BigInteger /local Sign_Negative[^\r\n]*/
-- SED Pylon.BigInteger /local Sign_Positive[^\r\n]*/
-- SED Pylon.BigInteger /function BigInteger.FromBlob.-\nend/
-- SED Pylon.BigInteger /function BigInteger.FromDecimal.-\nend/
-- SED Pylon.BigInteger /function BigInteger.FromUInt32.-\nend/
-- SED Pylon.BigInteger /function BigInteger.FromInt32.-\nend/
-- SED Pylon.BigInteger /function self:ctor.-\nend/
-- SED Pylon.BigInteger /function self:Clone.-\nend/
-- SED Pylon.BigInteger /function self:IsZero.-\nend/
-- SED Pylon.BigInteger /function self:IsNegative.-\nend/
-- SED Pylon.BigInteger /function self:IsOdd.-end/
-- SED Pylon.BigInteger /function self:Multiply.-\nend/
-- SED Pylon.BigInteger /function self:Square.-\nend/
-- SED Pylon.BigInteger /function self:Divide.-\nend/
-- SED Pylon.BigInteger /function self:Mod.-\nend/
-- SED Pylon.BigInteger /function self:ExponentiateMod.-\nend/
-- SED Pylon.BigInteger /function self:Normalize.-\nend/
-- SED Pylon.BigInteger /function self:Truncate.-\nend/
-- SED Pylon.BigInteger /local BigInteger_Truncate[^\r\n]*/
-- SED Pylon.BigInteger /function self:TruncateAndZero.-\nend/
-- SED Pylon.BigInteger /function self:ToBlob.-\nend/

local Carrier = {}
-- INCLUDE carrier/packages/carrier/developer.lua

local publicKeyExponent = BigInteger.FromDecimal (publicKeyExponent)
local publicKeyModulus  = BigInteger.FromDecimal (publicKeyModulus)

local function Log (message)
	print ("Carrier prebootstrap: " .. message)
end

local warningColor = Color (255, 192, 64)
local function Warning (message)
	MsgC (warningColor, "Carrier prebootstrap: " .. message .. "\n")
end

local function Reset ()
	file.Delete ("garrysmod.io/carrier/bootstrap.dat")
	file.Delete ("garrysmod.io/carrier/bootstrap.signature.dat")
	Warning ("Flushed cached bootstrap code.")
end

local function ValidateSignature (data, signature)
	local hook = { debug.gethook () }
	debug.sethook ()
	local sha256a = string.sub (BigInteger.FromBlob(signature):ExponentiateMod (publicKeyExponent, publicKeyModulus):ToBlob (), -32, -1)
	local sha256b = String.FromHex (Crypto.SHA256.Compute (data))
	debug.sethook (unpack (hook))
	return sha256a == sha256b
end

local function RunBootstrap (package, signature)
	if not ValidateSignature (package, signature) then return false, "Invalid bootstrap code signature!" end
	
	local code = string.match (package, "%-%- BEGIN CARRIER BOOTSTRAP.-%-%- END CARRIER BOOTSTRAP\r?\n")
	if not code then return false, "Bootstrap code not found!" end
	
	local f = CompileString (code, "carrier.bootstrap/carrier.bootstrap.lua", false)
	if type (f) == "string" then return false, f end
	
	local success, future = xpcall (f, debug.traceback)
	if not success then return false, future end
	if not future  then return false, "Bootstrap didn't return a future!" end
	
	future:Wait (
		function (success)
			if success then return end
			
			Warning ("Bootstrap failed!")
			Reset ()
		end
	)
	
	return true
end

local function Fetch (url, f, n)
	local n = n or 1
	http.Fetch (url,
		function (data)
			Log ("Fetched " .. url .. ".")
			f (true, data)
		end,
		function (err)
			if n == 10 then f (false) return end
			
			local delay = 1 * math.pow (2, n - 1)
			Warning ("Failed to fetch from " .. url .. ", retrying in " .. delay .. " second(s)...")
			timer.Simple (delay, function () Fetch (url, f, n + 1) end)
		end
	)
end

if Carrier.IsLocalDeveloperEnabled () then
	if file.Exists ("carrier/packages/carrier.bootstrap/carrier.bootstrap.lua", CLIENT and "LCL" or "LSV") then
		include ("carrier/packages/carrier.bootstrap/carrier.bootstrap.lua")
		return
	end
end

if Carrier.IsServerDeveloperEnabled () then
	if file.Exists ("carrier/packages/carrier.bootstrap/carrier.bootstrap.lua", "LUA") then
		include ("carrier/packages/carrier.bootstrap/carrier.bootstrap.lua")
		return
	end
end

local package   = file.Read ("garrysmod.io/carrier/bootstrap.dat", "DATA")
local signature = file.Read ("garrysmod.io/carrier/bootstrap.signature.dat", "DATA")
if package and signature then
	local success, err = RunBootstrap (package, signature)
	if success then return end
	
	Warning (err)
	Reset ()
end

-- Workaround for HTTP failed - ISteamHTTP isn't available!
hook.Add ("Tick", "Carrier.Preboostrap",
	function ()
		hook.Remove ("Tick", "Carrier.Preboostrap")
		
		Fetch ("https://garrysmod.io/api/packages/v1/bootstrap",
			function (success, data)
				if not success then
					Warning ("Failed to fetch bootstrap code, aborting!")
					return
				end
				
				local data = util.JSONToTable (data)
				if not data then
					Warning ("Bad response (" .. string.gsub (string.sub (data, 1, 128), "[\r\n]+", " ") .. ")")
					return
				end
				
				local package, signature = Base64.Decode (data.package), Base64.Decode (data.signature)
				file.CreateDir ("garrysmod.io/carrier")
				file.Write ("garrysmod.io/carrier/bootstrap.dat",           package)
				file.Write ("garrysmod.io/carrier/bootstrap.signature.dat", signature)
				
				local success, err = RunBootstrap (package, signature)
				if not success then
					Warning (err)
					Reset ()
				end
			end
		)
	end
)
