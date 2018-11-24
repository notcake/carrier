if EnumeratorFunction then
	EnumeratorFunction:dtor()
	
	-- Leave this in place so we can still create enumerators,
	-- just without the function extensions
	-- EnumeratorFunction = nil
end
