OOP = Carrier.LoadPackage("Pylon.OOP")
OOP.Initialize(_ENV)

CompactList = Carrier.LoadPackage ("Pylon.Structures.CompactList")

local self = {}
Future = Class (self)

function self:ctor ()
	self.Resolved = false
	
	self.ReturnCount, self.Returns = CompactList.Clear ()
	self.WaiterCount, self.Waiters = CompactList.Clear ()
end

function self:Map (f)
	local future = Future ()
	self:Wait (
		function (...)
			future:Resolve (f (...))
		end
	)
	return future
end

function self:MapAsync (f)
	local future = Future ()
	self:Wait (
		function (...)
			f (...):Wait (
				function (...)
					future:Resolve (...)
				end
			)
		end
	)
	return future
end

function self:Resolve (...)
	assert (not self.Resolved, "Future resolved twice!")
	
	self.Resolved = true
	self.ReturnCount, self.Returns = CompactList.Pack (...)
	
	for f in CompactList.Enumerator (self.WaiterCount, self.Waiters) do
		f (CompactList.Unpack (self.ReturnCount, self.Returns))
	end
	
	self.WaiterCount, self.Waiters = CompactList.Clear (self.WaiterCount, self.Waiters)
end

function self:Wait (f)
	if self.Resolved then
		f (CompactList.Unpack (self.ReturnCount, self.Returns))
	else
		self.WaiterCount, self.Waiters = CompactList.Append (self.WaiterCount, self.Waiters, f)
	end
end

function self:Await ()
	if self.Resolved then
		return CompactList.Unpack (self.ReturnCount, self.Returns)
	else
		local thread = coroutine.running ()
		self:Wait(
			function (...)
				coroutine.resume (thread, ...)
			end
		)
	end
	
	return coroutine.yield ()
end

function Future.Resolved (...)
	local future = Future ()
	future:Resolve(...)
	return future
end

function Future.Join (...)
	local count = select ("#", ...)
	return Future.JoinArray ({...}):Map (
		function (array)
			return unpack (array, 1, count)
		end
	)
end

function Future.JoinArray (array)
	local count = #array
	if count == 0 then return Future.resolved () end
	
	local future = Future ()
	local results = {}
	local i = 0
	for k, f in ipairs (array) do
		f:Wait (
			function ()
				results[k] = select ("#", ...) > 1 and {...} or ...
			
				i = i + 1
				if i == count then
					future:Resolve (results)
				end
			end
		)
	end
	return future
end

return Future
