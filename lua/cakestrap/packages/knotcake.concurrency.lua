Concurrency = {}

Concurrency.Error = CakeStrap.LoadPackage ("Error")

function Concurrency.RunTask (t, ...)
	if type (t) == "function" then
		local f = t
		t = coroutine.create (
			function (...)
				local success, message = xpcall (f,
					function (message)
						return tostring (message) .. "\n" .. XC.StackTrace ()
					end,
					...
				)
				if not success then
					error (message)
				end
			end
		)
	end
	
	local success, message = coroutine.resume (t, ...)
	if not success then
		Concurrency.Error ("Knotcake.Concurrency.RunTask : " .. message)
	end
	
	return success, message
end

function Concurrency.Sleep (durationInMilliseconds)
	assert (coroutine.running ())
	
	local resumed          = false
	local currentCoroutine = coroutine.running ()
	
	timer.Simple (milliseconds * 1000,
		function ()
			resumed = true
			coroutine.resume (currentCoroutine)
		end
	)
	
	if resumed then return end
	return coroutine.yield ()
end

function Concurrency.Initialize (destinationTable)
	destinationTable.RunTask = Concurrency.RunTask
end

return Concurrency