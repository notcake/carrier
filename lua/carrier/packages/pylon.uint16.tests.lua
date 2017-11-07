-- PACKAGE Pylon.UInt16.Tests

local Clock  = require_provider ("Pylon.MonotonicClock")
local Util   = require ("Pylon.Util")
local UInt16 = require ("Pylon.UInt16")

--[[
	Identity took 7.35 ns
	UInt16.Add took 11.18 ns
	UInt16.AddWithCarry took 12.97 ns
	UInt16.Subtract took 11.18 ns
	UInt16.SubtractWithBorrow took 13.43 ns
	UInt16.Multiply took 12.44 ns
]]

return function ()
	local arg0 = {}
	local arg1 = {}
	local arg2 = {}
	for i = 1, 1000000 do
		arg0 [i] = math.random (0, 0xFFFF)
		arg1 [i] = math.random (0, 0xFFFF)
		arg2 [i] = math.random (0, 1)
	end

	local function Profile (name, f)
		if not f then return 0 end
		
		local t0 = Clock ()
		local r0, r1 = 0, 0
		for i = 1, 1000000 do
			r0, r1 = f ((arg0 [i] + r0) % 0x00010000, (arg1 [i] + r1) % 0x00010000, arg2 [i])
		end
		
		local dt = (Clock () - t0) / 1000000
		print (name .. " took " .. Util.Duration.Format (dt))
		return dt
	end

	Profile ("Identity",                           function (a, b) return a, b end)
	Profile ("UInt16.Add",                         UInt16.Add)
	Profile ("UInt16.AddWithCarry",                UInt16.AddWithCarry)
	Profile ("UInt16.Subtract",                    UInt16.Subtract)
	Profile ("UInt16.SubtractWithBorrow",          UInt16.SubtractWithBorrow)
	Profile ("UInt16.Multiply",                    UInt16.Multiply)
end
