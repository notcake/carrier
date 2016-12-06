OOP = Carrier.LoadPackage("Pylon.OOP")
OOP.Initialize(_ENV)

CompactList = Carrier.LoadPackage("Pylon.Structures.CompactList")

local self = {}
Future = Class(self)

function self:ctor ()
	self.resolved = false
	
	self.returnCount, self.returns = CompactList.clear()
	self.waiterCount, self.waiters = CompactList.clear()
end

function self:map(f)
	local future = Future()
	self:wait(
		function(...)
			future:resolve(f(...))
		end
	)
	return future
end

function self:mapAsync(f)
	local future = Future()
	self:wait(
		function(...)
			f(...):wait (
				function(...)
					future:resolve(...)
				end
			)
		end
	)
	return future
end

function self:resolve(...)
	assert(not self.resolved, "Future resolved twice!")
	
	self.resolved = true
	self.returnCount, self.returns = CompactList.pack(...)
	
	for f in CompactList.enumerator(self.waiterCount, self.waiters) do
		f(CompactList.unpack(self.returnCount, self.returns))
	end
	
	self.waiterCount, self.waiters = CompactList.clear(self.waiterCount, self.waiters)
end

function self:wait(f)
	if self.resolved then
		f(CompactList.unpack(self.returnCount, self.returns))
	else
		self.waiterCount, self.waiters = CompactList.append(self.waiterCount, self.waiters, f)
	end
end

function self:await()
	if self.resolved then
		return CompactList.unpack(self.returnCount, self.returns)
	else
		local thread = coroutine.running()
		self:wait(
			function(...)
				coroutine.resume(thread, ...)
			end
		)
	end
	
	return coroutine.yield()
end

function Future.resolved(...)
	local future = Future()
	future:resolve(...)
	return future
end

function Future.join(...)
	return Future.joinArray({...})
end

function Future.joinArray(array)
	local count = #array
	if count == 0 then return Future.resolved() end
	
	local future = Future()
	local i = 0
	for _, f in ipairs(array) do
		f:wait(
			function()
				i = i + 1
				if i == count then
					future:resolve()
				end
			end
		)
	end
	return future
end

return Future
