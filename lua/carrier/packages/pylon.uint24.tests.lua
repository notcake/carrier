-- PACKAGE Pylon.UInt24.Tests

local Clock  = require_provider("Pylon.MonotonicClock")
local Util   = require("Pylon.Util")
local UInt24 = require("Pylon.UInt24")

--[[
	Identity took 7.24 ns
	UInt24.Add took 11.14 ns
	UInt24.AddWithCarry took 12.47 ns
	UInt24.Subtract took 11.47 ns
	UInt24.SubtractWithBorrow took 12.77 ns
	UInt24.Multiply took 11.86 ns
]]

return function()
	local arg0 = {}
	local arg1 = {}
	local arg2 = {}
	for i = 1, 1000000 do
		arg0[i] = math.random(0, 0x00FFFFFF)
		arg1[i] = math.random(0, 0x00FFFFFF)
		arg2[i] = math.random(0, 1)
	end

	local function Profile(name, f)
		if not f then return 0 end
		
		local t0 = Clock()
		local r0, r1 = 0, 0
		for i = 1, 1000000 do
			r0, r1 = f((arg0[i] + r0) % 0x01000000, (arg1[i] + r1) % 0x01000000, arg2[i])
		end
		
		local dt = (Clock() - t0) / 1000000
		print(name .. " took " .. Util.Duration.Format(dt))
		return dt
	end

	Profile("Identity",                           function(a, b) return a, b end)
	Profile("UInt24.Add",                         UInt24.Add)
	Profile("UInt24.AddWithCarry",                UInt24.AddWithCarry)
	Profile("UInt24.Subtract",                    UInt24.Subtract)
	Profile("UInt24.SubtractWithBorrow",          UInt24.SubtractWithBorrow)
	Profile("UInt24.Multiply",                    UInt24.Multiply)
end
