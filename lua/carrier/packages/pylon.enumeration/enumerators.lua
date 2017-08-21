local CompactList = require ("Pylon.Containers.CompactList")

local pairs = pairs

local coroutine_create = coroutine.create
local coroutine_resume = coroutine.resume
local coroutine_status = coroutine.status

function Enumeration.ArrayEnumerator (tbl)
	local i = 0
	return EnumeratorFunction:RegisterFunction (
		function ()
			i = i + 1
			return tbl [i]
		end
	)
end

function Enumeration.KeyEnumerator (tbl)
	local next, tbl, key = pairs (tbl)
	return EnumeratorFunction:RegisterFunction (
		function ()
			key = next (tbl, key)
			return key
		end
	)
end

function Enumeration.ValueEnumerator (tbl)
	local next, tbl, key = pairs (tbl)
	return EnumeratorFunction:RegisterFunction (
		function ()
			key = next (tbl, key)
			return tbl [key]
		end
	)
end

function Enumeration.KeyValueEnumerator (tbl)
	local next, tbl, key = pairs (tbl)
	return EnumeratorFunction:RegisterFunction (
		function ()
			key = next (tbl, key)
			return key, tbl [key]
		end
	)
end

function Enumeration.ValueKeyEnumerator (tbl)
	local next, tbl, key = pairs (tbl)
	return EnumeratorFunction:RegisterFunction (
		function ()
			key = next (tbl, key)
			return tbl [key], key
		end
	)
end

function Enumeration.NullEnumerator ()
	return EnumeratorFunction:RegisterFunction (
		function ()
			return nil
		end
	)
end

function Enumeration.SingleValueEnumerator (v)
	local done = false
	return EnumeratorFunction:RegisterFunction (
		function ()
			if done then return nil end
			done = true
			return v
		end
	)
end

function Enumeration.YieldEnumerator (f)
	local thread = coroutine_create (f)
	return EnumeratorFunction:RegisterFunction (
		function ()
			if coroutine_status (thread) == "dead" then return nil end
			local success, a, b, c, d, e, f = coroutine_resume (thread)
			if not success then
				Error (a)
				return nil
			end
			return a, b, c, d, e, f
		end
	)
end

function Enumeration.YieldEnumeratorFactory (f)
	return function (...)
		local argumentCount, arguments = CompactList.Pack (...)
		
		return Enumerator.YieldEnumerator (
			function ()
				return f (CompactList.Unpack (argumentCount, arguments))
			end
		)
	end
end
