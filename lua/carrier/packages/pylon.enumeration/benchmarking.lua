debug.sethook()

local n = 500
function GetEnumerator1()
	local x = 0
	return function()
		x = x + 1
		if x > n then return nil end
		return x
	end
end

local array = {}
for i = 1, n do array[i] = i end

function GetEnumerator2()
	local next, tbl, key = pairs(array)
	return function()
		key = next(tbl, key)
		return key
	end
end

function GetEnumerator3()
	local next, tbl, key = pairs(array)
	return function()
		key = next(tbl, key)
		return tbl[key]
	end
end

function GetEnumerator4()
	local next, tbl, key = ipairs(array)
	return function()
		key = next(tbl, key)
		return key
	end
end

function GetEnumerator5()
	local next, tbl, key = ipairs(array)
	return function()
		key = next(tbl, key)
		return tbl[key]
	end
end

local coroutine_yield = coroutine.yield
function GetEnumerator6()
	for i = 1, n do
		coroutine_yield(i)
	end
end

local coroutine_resume = coroutine.resume
local coroutine_status = coroutine.status
function YieldEnumerator(f)
	local thread = coroutine.create(f)
	return function()
		if coroutine_status(thread) == "dead" then return nil end
		local success, a = coroutine_resume(thread)
		if not success then
			GLib.Error(a)
			return nil
		end
		return a
	end
end

function YieldEnumeratorFactory(f)
	return function(...)
		local arguments = {...}
		local argumentCount = select("#", ...)
		
		return YieldEnumerator(
			function()
				return f(unpack(arguments, 1, argumentCount))
			end
		)
	end
end
GetEnumerator6 = YieldEnumeratorFactory(GetEnumerator6)

local proxyStates = GLib.WeakKeyTable()
local proxyMetatable =
{
	__call = function(self)
		proxyStates[self] = proxyStates[self] + 1
		if proxyStates[self] > n then return nil end
		return proxyStates[self]
	end
}
function GetEnumerator7()
	local obj = newproxy()
	proxyStates[obj] = 0
	debug.setmetatable(obj, proxyMetatable)
	return obj
end

local Enumeration = require("Pylon.Enumeration")

local self = {}
GetEnumerator8 = GLib.MakeConstructor(self)

function self:ctor()
	self.Index = 0
end

function self:__call()
	self.Index = self.Index + 1
	if self.Index > n then return nil end
	
	return self.Index
end

function GetEnumerator9()
	return Enumeration.FunctionEnumerator(GetEnumerator3())
end

function GetEnumerator10()
	return Enumeration.ValueEnumerator(array)
end

MsgN("iterator                                    enumerator from 1 to " .. n .. " 100 times takes ", GLib.FormatDuration(Profiler:Profile(function() for i = 1, 100 do for x in GetEnumerator1 () do end end end)))
MsgN("pairs key                                   enumerator from 1 to " .. n .. " 100 times takes ", GLib.FormatDuration(Profiler:Profile(function() for i = 1, 100 do for x in GetEnumerator2 () do end end end)))
MsgN("pairs value                                 enumerator from 1 to " .. n .. " 100 times takes ", GLib.FormatDuration(Profiler:Profile(function() for i = 1, 100 do for x in GetEnumerator3 () do end end end)))
MsgN("ipairs key                                  enumerator from 1 to " .. n .. " 100 times takes ", GLib.FormatDuration(Profiler:Profile(function() for i = 1, 100 do for x in GetEnumerator4 () do end end end)))
MsgN("ipairs value                                enumerator from 1 to " .. n .. " 100 times takes ", GLib.FormatDuration(Profiler:Profile(function() for i = 1, 100 do for x in GetEnumerator5 () do end end end)))
MsgN("coroutine                                   enumerator from 1 to " .. n .. " 100 times takes ", GLib.FormatDuration(Profiler:Profile(function() for i = 1, 100 do for x in GetEnumerator6 () do end end end)))
MsgN("newproxy                                    enumerator from 1 to " .. n .. " 100 times takes ", GLib.FormatDuration(Profiler:Profile(function() for i = 1, 100 do for x in GetEnumerator7 () do end end end)))
MsgN("class                                       enumerator from 1 to " .. n .. " 100 times takes ", GLib.FormatDuration(Profiler:Profile(function() for i = 1, 100 do for x in GetEnumerator8 () do end end end)))
MsgN("FunctionEnumerator(FunctionValueEnumerator) enumerator from 1 to " .. n .. " 100 times takes ", GLib.FormatDuration(Profiler:Profile(function() for i = 1, 100 do for x in GetEnumerator9 () do end end end)))
MsgN("ValueEnumerator()                           enumerator from 1 to " .. n .. " 100 times takes ", GLib.FormatDuration(Profiler:Profile(function() for i = 1, 100 do for x in GetEnumerator10() do end end end)))

--[[
	Output:
		iterator     enumerator from 1 to 500 100 times takes 1.52 ms
		pairs key    enumerator from 1 to 500 100 times takes 2.04 ms
		pairs value  enumerator from 1 to 500 100 times takes 2.42 ms
		ipairs key   enumerator from 1 to 500 100 times takes 1.77 ms
		ipairs value enumerator from 1 to 500 100 times takes 2.47 ms
		coroutine    enumerator from 1 to 500 100 times takes 6.79 ms
		newproxy     enumerator from 1 to 500 100 times takes 5.75 ms
		class        enumerator from 1 to 500 100 times takes 3.45 ms
]]
