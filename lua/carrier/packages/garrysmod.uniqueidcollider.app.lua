-- PACKAGE GarrysMod.UniqueIdCollider.App
local UniqueIdCollider = require ("GarrysMod.UniqueIdCollider")

if not arg or #arg == 0 then
	print ("Usage: " .. arg [0] .. "<uniqueId>")
else
	local uniqueId = tonumber (arg [1])
	if not uniqueId then
		print ("Usage: " .. arg [0] .. "<uniqueId>")
	else
		local results = UniqueIdCollider (uniqueId)
		print (string.format ("%d results for %s:", #results, arg [1]))
		for _, v in ipairs (results) do
			print ("\t" .. v)
		end
	end
end
