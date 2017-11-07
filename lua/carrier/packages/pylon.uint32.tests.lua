-- PACKAGE Pylon.UInt32.Tests

local Clock  = require_provider ("Pylon.MonotonicClock")
local Util   = require ("Pylon.Util")
local UInt32 = require ("Pylon.UInt32")

--[[
	Identity took 7.41 ns
	UInt32.Add took 14.20 ns
	UInt32.AddBranching took 27.88 ns
	UInt32.AddWithCarry took 15.18 ns
	UInt32.AddWithCarryBranching took 39.76 ns
	UInt32.Subtract took 14.18 ns
	UInt32.SubtractBranching took 49.42 ns
	UInt32.SubtractWithBorrow took 15.30 ns
	UInt32.SubtractWithBorrowBranching took 61.67 ns
	UInt32.Multiply took 25.31 ns
]]

return function ()
	local arg0 = {}
	local arg1 = {}
	local arg2 = {}
	for i = 1, 1000000 do
		arg0 [i] = math.random (0, 0xFFFFFFFF)
		arg1 [i] = math.random (0, 0xFFFFFFFF)
		arg2 [i] = math.random (0, 1)
	end

	local function Profile (name, f)
		if not f then return 0 end
		
		local t0 = Clock ()
		local r0, r1 = 0, 0
		for i = 1, 1000000 do
			r0, r1 = f ((arg0 [i] + r0) % 4294967296, (arg1 [i] + r1) % 4294967296, arg2 [i])
		end
		
		local dt = (Clock () - t0) / 1000000
		print (name .. " took " .. Util.Duration.Format (dt))
		return dt
	end

	Profile ("Identity",                           function (a, b) return a, b end)
	Profile ("UInt32.Add",                         UInt32.Add)
	Profile ("UInt32.AddBranching",                UInt32.AddBranching)
	Profile ("UInt32.AddWithCarry",                UInt32.AddWithCarry)
	Profile ("UInt32.AddWithCarryBranching",       UInt32.AddWithCarryBranching)
	Profile ("UInt32.Subtract",                    UInt32.Subtract)
	Profile ("UInt32.SubtractBranching",           UInt32.SubtractBranching)
	Profile ("UInt32.SubtractWithBorrow",          UInt32.SubtractWithBorrow)
	Profile ("UInt32.SubtractWithBorrowBranching", UInt32.SubtractWithBorrowBranching)
	Profile ("UInt32.Multiply",                    UInt32.Multiply)
end
