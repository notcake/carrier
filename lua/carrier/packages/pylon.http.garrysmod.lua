GarrysMod = {}

HTTP = Carrier.LoadPackage ("Pylon.HTTP")
HTTP.Initialize (GarrysMod)

function GarrysMod.Get (url)
	assert (coroutine.running ())
	
	local thread = coroutine.running ()
	
	local resumed = false
	local returnValues = nil
	http.Fetch (url,
		function (content, contentLength, headers, code)
			resumed = true
			response = HTTP.HTTPResponse.FromHTTPResponse (url, code, content, headers)
			coroutine.resume (thread, response)
		end,
		function (error)
			resumed = true
			response = HTTP.HTTPResponse.FromFailure (url, error)
			coroutine.resume (thread, response)
		end
	)
	
	if resumed then return response end
	
	return coroutine.yield ()
end

function GarrysMod.Post (url, parameters)
	assert (coroutine.running ())
	
	local thread = coroutine.running ()
	
	local resumed = false
	local response = nil
	http.Post (url, parameters,
		function (content, contentLength, headers, code)
			resumed = true
			response = HTTP.HTTPResponse.FromHTTPResponse (url, code, content, headers)
			coroutine.resume (thread, response)
		end,
		function (error)
			resumed = true
			response = HTTP.HTTPResponse.FromFailure (url, error)
			coroutine.resume (thread, response)
		end
	)
	
	if resumed then return response end
	
	return coroutine.yield ()
end

return GarrysMod
