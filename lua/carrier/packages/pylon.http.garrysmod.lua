local GarrysMod = {}

local HTTP = Carrier.LoadPackage ("Pylon.HTTP")
HTTP.Initialize (GarrysMod)

local Future = Carrier.LoadPackage ("Pylon.Future")

function GarrysMod.Get (url)
	local future = Future ()
	http.Fetch (url,
		function (content, contentLength, headers, code)
			local response = HTTP.HTTPResponse.FromHTTPResponse (url, code, content, headers)
			future:Resolve (response)
		end,
		function (error)
			local response = HTTP.HTTPResponse.FromFailure (url, error)
			future:Resolve (response)
		end
	)
	return future
end

function GarrysMod.Post (url, parameters)
	local future = Future ()
	http.Post (url, parameters,
		function (content, contentLength, headers, code)
			local response = HTTP.HTTPResponse.FromHTTPResponse (url, code, content, headers)
			future:Resolve (response)
		end,
		function (error)
			local response = HTTP.HTTPResponse.FromFailure (url, error)
			future:Resolve (response)
		end
	)
	return future
end

return GarrysMod
