Aether.API = Aether.API or {}

function Aether.API.Post (url, data)
	return Task.Run (
		function ()
			local response = HTTP.Post ("https://garrysmod.io" .. url, data):Await ()
			if not response:IsSuccess () then return false, response:GetMessage () end
			
			local data = util.JSONToTable (response:GetContent ())
			if not data then return false, nil end
			
			if not data.success then return false, data.error end
			
			return true, data
		end
	)
end
