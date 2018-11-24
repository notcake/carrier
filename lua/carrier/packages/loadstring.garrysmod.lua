-- PACKAGE loadstring.GarrysMod
return function(code, path)
	path = path or "=(load)"
	local f = CompileString(code, path, false)
	if type(f) == "function" then
		return f
	else
		return nil, f
	end
end
