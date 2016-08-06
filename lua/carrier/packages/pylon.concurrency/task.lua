local self = {}
Concurrency.Task = Class (self)

function self:ctor (f, ...)
	self.Coroutine = coroutine.create (
		function (...)
			local success, r0 = xpcall (f,
				function (message)
					return tostring (message) .. "\n" .. XC.StackTrace ()
				end,
				...
			)
			if not success then
				print (r0)
				
				-- Rethrow
				error (r0)
			end
			
			return r0
		end
	)
	
	self.Started = false
	
	self.Arguments     = nil
	self.ArgumentCount = 0
	
	if ... then
		self.Arguments     = { ... }
		self.ArgumentCount = table.maxn (self.Arguments)
	end
end

function self:Run ()
	if self.Started then return end
	
	self.Started = true
	
	if self.Arguments then
		coroutine.resume (self.Coroutine, unpack (self.Arguments, 1, self.ArgumentCount))
	else
		coroutine.resume (self.Coroutine)
	end
end
