-- BEGIN CARRIER BOOTSTRAP

-- INCLUDE Pylon.Error

local Algorithms = {}
-- INCLUDE carrier/packages/pylon.algorithms/depthfirstsearch.lua

local OOP = {}
-- SED Pylon.OOP /function OOP%.Class.-\nend/
-- INCLUDE carrier/packages/pylon.oop/class.lua
-- INCLUDE carrier/packages/pylon.oop/enum.lua
local Class     = OOP.Class
local Enum      = OOP.Enum
local Interface = Class

-- INCLUDE Pylon.Containers.CompactList
local Enumeration = {}
local EnumeratorFunction = {}
function EnumeratorFunction:RegisterFunction (f) return f end
-- INCLUDE carrier/packages/pylon.enumeration/enumerators.lua
local ValueEnumerator = Enumeration.ValueEnumerator
local KeyValueEnumerator = Enumeration.KeyValueEnumerator

-- INCLUDE Pylon.Future
-- INCLUDE Pylon.Functional
local f = Functional
-- INCLUDE Pylon.Task

local HTTP = {}
function HTTP.Initialize () end
-- SED Pylon.HTTP /local.-\nend/
-- SED Pylon.HTTP /function HTTP.EncodeUriComponent.-\nend/
HTTP.HTTPCodes = {}
function HTTP.HTTPCodes.ToMessage () return "" end
-- INCLUDE carrier/packages/pylon.http/httpresponse.lua
-- INCLUDE Pylon.HTTP.GarrysMod
HTTP.Get  = GarrysMod.Get
HTTP.Post = GarrysMod.Post

local Crypto = {}
-- INCLUDE carrier/packages/pylon.crypto/sha256.lua
-- INCLUDE carrier/packages/pylon.crypto/md5.lua

-- INCLUDE Pylon.MonotonicClock.GarrysMod
local Clock = GarrysMod
-- INCLUDE Pylon.Base64
-- INCLUDE Pylon.String
-- INCLUDE Pylon.UInt24
-- INCLUDE Pylon.BigInteger

-- INCLUDE Pylon.BitConverter

local IO = {}
-- INCLUDE carrier/packages/pylon.io/endianness.lua
-- INCLUDE carrier/packages/pylon.io/ibasestream.lua
-- INCLUDE carrier/packages/pylon.io/iinputstream.lua
-- INCLUDE carrier/packages/pylon.io/ioutputstream.lua
-- INCLUDE carrier/packages/pylon.io/istreamreader.lua
-- INCLUDE carrier/packages/pylon.io/istreamwriter.lua
-- INCLUDE carrier/packages/pylon.io/streamreader.lua
-- INCLUDE carrier/packages/pylon.io/streamwriter.lua
-- INCLUDE carrier/packages/pylon.io/stringinputstream.lua
-- INCLUDE carrier/packages/pylon.io/stringoutputstream.lua

local GarrysMod = IO
-- INCLUDE carrier/packages/pylon.io.garrysmod/fileinputstream.lua
-- INCLUDE carrier/packages/pylon.io.garrysmod/fileoutputstream.lua

-- INCLUDE Carrier.PublicKey

local Verification = {}
-- INCLUDE carrier/packages/panopticon.verification/luafile.lua

local PackageFile = {}
-- INCLUDE carrier/packages/carrier.packagefile/packagefile.lua
-- INCLUDE carrier/packages/carrier.packagefile/section.lua
-- INCLUDE carrier/packages/carrier.packagefile/unknownsection.lua
-- INCLUDE carrier/packages/carrier.packagefile/dependenciessection.lua
-- INCLUDE carrier/packages/carrier.packagefile/filesystemsection.lua
-- INCLUDE carrier/packages/carrier.packagefile/filesystemfile.lua
-- INCLUDE carrier/packages/carrier.packagefile/luahashessection.lua
-- INCLUDE carrier/packages/carrier.packagefile/signaturesection.lua

local Carrier = {}
-- SED carrier/packages/carrier/_ctor.lua /function.+end/
-- INCLUDE carrier/packages/carrier/developer.lua
-- INCLUDE carrier/packages/carrier/packages.lua
-- INCLUDE carrier/packages/carrier/package.lua
-- INCLUDE carrier/packages/carrier/ipackagerelease.lua
-- INCLUDE carrier/packages/carrier/packagerelease.lua
-- INCLUDE carrier/packages/carrier/localdeveloperpackagerelease.lua
-- INCLUDE carrier/packages/carrier/remotedeveloperpackagerelease.lua

Carrier.Packages = Carrier.Packages ()

local function WithJIT (f, ...)
	local hook = { debug.gethook () }
	debug.sethook ()
	return (
		function (...)
			debug.sethook (unpack (hook))
			return ...
		end
	) (f (...))
end

return Task.Run (
	function ()
		if _G.Carrier and
		   type (_G.Carrier.Uninitialize) == "function" then
			_G.Carrier.Uninitialize ()
		end
		
		local carrier = nil
		local developerRelease = Carrier.Packages:GetLocalDeveloperRelease ("Carrier")
		if Carrier.IsLocalDeveloperEnabled () and developerRelease then
			carrier = Carrier.Packages:Load ("Carrier", developerRelease:GetVersion ())
		else
			Carrier.Packages:LoadMetadata ()
			local downloadRequired = not Carrier.Packages:IsPackageReleaseAvailableRecursive ("Carrier")
			
			if downloadRequired then
				Carrier.Packages:Update ():Await ()
				Carrier.Packages:Download ("Carrier"):Await ()
			end
			
			carrier = WithJIT (Carrier.Packages.Load, Carrier.Packages, "Carrier")
			
			-- Update and retry on failure
			if not carrier and not downloadRequired then
				Carrier.Packages:Update ():Await ()
				Carrier.Packages:Download ("Carrier"):Await ()
				carrier = WithJIT (Carrier.Packages.Load, Carrier.Packages, "Carrier")
			end
		end
		
		if not carrier then return false end
		
		-- Load package listing
		carrier.Packages:LoadMetadata ()
		
		-- Assimilate existing packages
		for packageName, bootstrapPackage in pairs (Carrier.Packages.LoadedPackages) do
			local package = carrier.Packages:GetPackage (packageName)
			bootstrapPackage:AssimilateInto (carrier.Packages, package)
		end
		
		-- Initialize
		carrier.Packages:Initialize ()
		
		_G.Carrier = _G.Carrier or {}
		_G.Carrier.Uninitialize = function () carrier.Packages:Uninitialize () end
		_G.Carrier.Require = function (packageName) return carrier.Packages:Load (packageName) end
		_G.Carrier.require = _G.Carrier.Require
		
		return true
	end
)

-- END CARRIER BOOTSTRAP
