-- PACKAGE Pylon.HTTP.GarrysMod

local GarrysMod = {}

local HTTP = require ("Pylon.HTTP")
HTTP.Initialize (GarrysMod)

local Future = require ("Pylon.Future")

-- Workaround for HTTP failed - ISteamHTTP isn't available!
local ready = CurTime () > 0
local requestQueue = nil

local function DispatchRequest (f, ...)
	if ready then f (...) return end
	
	if requestQueue == nil then
		requestQueue = {}
		
		hook.Add ("Tick", "Pylon.HTTP.GarrysMod",
			function ()
				hook.Remove ("Tick", "Pylon.HTTP.GarrysMod")
				ready = true
				
				for i = 1, #requestQueue do
					requestQueue [i] ()
				end
				
				requestQueue = nil
			end
		)
	end
	
	local arguments = {...}
	local argumentCount = select ("#", ...)
	requestQueue [#requestQueue + 1] = function ()
		f (unpack (arguments, 1, argumentCount))
	end
end

function GarrysMod.Get (url)
	local future = Future ()
	DispatchRequest (
		http.Fetch,
		url,
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
	DispatchRequest (
		http.Post,
		url, parameters,
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
