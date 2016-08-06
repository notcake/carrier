Concurrency = {}

Error = Carrier.LoadPackage ("Pylon.Error")
OOP   = Carrier.LoadPackage ("Pylon.OOP")
OOP.Initialize (_ENV)

include ("task.lua")

function Concurrency.CanYield ()
	return coroutine.running () ~= nil
end

function Concurrency.Sleep (durationInMilliseconds)
	assert (coroutine.running ())
	
	local resumed          = false
	local currentCoroutine = coroutine.running ()
	
	timer.Simple (durationInMilliseconds / 1000,
		function ()
			resumed = true
			coroutine.resume (currentCoroutine)
		end
	)
	
	if resumed then return end
	return coroutine.yield ()
end

function Concurrency.Initialize (destinationTable)
	destinationTable.Task  = Concurrency.Task
	
	destinationTable.Sleep = Concurrency.Sleep
end

return Concurrency
