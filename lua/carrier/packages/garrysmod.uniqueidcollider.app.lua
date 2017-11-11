-- PACKAGE GarrysMod.UniqueIdCollider.App
local UniqueIdCollider = require ("GarrysMod.UniqueIdCollider")

return function (command, uniqueId)
	if not uniqueId then
		print ("Usage: " .. command .. " <uniqueId>")
	else
		local uniqueId = tonumber (uniqueId)
		if not uniqueId then
			print ("Usage: " .. command .. " <uniqueId>")
		else
			local results = UniqueIdCollider (uniqueId)
			print (string.format ("%d results for %s:", #results, uniqueId))
			for _, v in ipairs (results) do
				print ("\t" .. v)
			end
		end
	end
end
