-- PACKAGE Pylon.Async.GarrysMod

local CompactList = require("Pylon.Containers.CompactList")
local Future      = require("Pylon.Future")
local Clock       = require_provider("Pylon.MonotonicClock")

local Async = {}

function Async.Wait(delay)
	local future = Future()
	timer.Simple(delay, function() future:Resolve() end)
	return future
end

Async.Sleep = Async.Wait

-- WaitTick
local tickWaiterCount, tickWaiters = CompactList.Clear()
function Async.WaitTick()
	local future = Future()
	tickWaiterCount, tickWaiters = CompactList.Append(tickWaiterCount, tickWaiters, future)
	return future
end

hook.Add(MENU_DLL and "Think" or "Tick", "Pylon.Async.GarrysMod",
	function()
		local previousTickWaiterCount, previousTickWaiters = tickWaiterCount, tickWaiters
		tickWaiterCount, tickWaiters = CompactList.Clear()
		for f in CompactList.Enumerator(previousTickWaiterCount, previousTickWaiters) do
			f:Resolve()
		end
	end
)

-- AwaitQuota
local quotaStartTimes = {}
function Async.AwaitQuota(maximumDuration)
	local maximumDuration = maximumDuration or 0.0025 -- s
	local thread = coroutine.running()
	local t0 = quotaStartTimes[thread] or -math.huge
	if Clock() - t0 > maximumDuration then
		Async.WaitTick():wait(
			function()
				quotaStartTimes[thread] = Clock()
				coroutine.resume(thread)
				quotaStartTimes[thread] = nil
			end
		)
		coroutine.yield()
	end
end

return Async
