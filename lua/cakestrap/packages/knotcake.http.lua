HTTP = {}

function HTTP.Get (url)
	assert (coroutine.running ())
	
	local resumed = false
	local returnValues = nil
	http.Fetch (url,
		function (...)
			resumed = true
			returnValues = { true, ... }
			coroutine.resume (true, ...)
		end,
		function (...)
			resumed = true
			returnValues = { false, ... }
			coroutine.resume (false, ...)
		end
	)
	
	if resumed then
		return unpack (returnValues)
	end
	
	return coroutine.yield ()
end

function HTTP.Post (url, parameters)
	assert (coroutine.running ())
	
	local resumed = false
	local returnValues = nil
	http.Post (url, parameters,
		function (...)
			resumed = true
			returnValues = { true, ... }
			coroutine.resume (true, ...)
		end,
		function (...)
			resumed = true
			returnValues = { false, ... }
			coroutine.resume (false, ...)
		end
	)
	
	if resumed then
		return unpack (returnValues)
	end
	
	return coroutine.yield ()
end

return HTTP