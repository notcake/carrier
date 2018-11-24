-- PACKAGE Pylon.HTTP.GarrysMod

local GarrysMod = {}

local HTTP = require("Pylon.HTTP")
HTTP.Initialize(GarrysMod)

local Future = require("Pylon.Future")

-- Workaround for HTTP failed - ISteamHTTP isn't available!
-- Note that CurTime starts at 1.0049999952316!
local ready = CLIENT or CurTime() > 1.5
local requestQueue = nil

local function DispatchRequest(f, ...)
	if ready then f(...) return end
	
	if requestQueue == nil then
		requestQueue = {}
		
		local sv_hibernate_think = GetConVarNumber("sv_hibernate_think")
		if sv_hibernate_think <= 0 then RunConsoleCommand("sv_hibernate_think", "1") end
		hook.Add("Tick", "Pylon.HTTP.GarrysMod",
			function()
				hook.Remove("Tick", "Pylon.HTTP.GarrysMod")
				if sv_hibernate_think <= 0 then RunConsoleCommand("sv_hibernate_think", tostring(sv_hibernate_think)) end
				
				ready = true
				
				for i = 1, #requestQueue do
					requestQueue[i]()
				end
				
				requestQueue = nil
			end
		)
	end
	
	local arguments = {...}
	local argumentCount = select("#", ...)
	requestQueue[#requestQueue + 1] = function()
		f(unpack(arguments, 1, argumentCount))
	end
end

function GarrysMod.Get(url)
	local future = Future()
	DispatchRequest(
		http.Fetch,
		url,
		function(content, contentLength, headers, code)
			local response = HTTP.HTTPResponse.FromHTTPResponse(url, code, content, headers)
			future:Resolve(response)
		end,
		function(error)
			local response = HTTP.HTTPResponse.FromFailure(url, error)
			future:Resolve(response)
		end
	)
	return future
end

function GarrysMod.Post(url, parameters)
	local future = Future()
	DispatchRequest(
		http.Post,
		url, parameters,
		function(content, contentLength, headers, code)
			local response = HTTP.HTTPResponse.FromHTTPResponse(url, code, content, headers)
			future:Resolve(response)
		end,
		function(error)
			local response = HTTP.HTTPResponse.FromFailure(url, error)
			future:Resolve(response)
		end
	)
	return future
end

return GarrysMod
