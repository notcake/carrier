local OOP = require ("Pylon.OOP")

local self = {}
Pool = OOP.Class (self)

function self:ctor (factory, initializer, scrubber, destroyer)
	self.Factory     = factory
	self.Initializer = initializer
	self.Scrubber    = scrubber
	self.Destroyer   = destroyer
	
	self.TotalSize = 0
	self.Pool = {}
end

function self:dtor ()
	if self.Destroyer then
		self:Clear ()
	end
end

function self:Alloc (...)
	if #self.Pool > 0 then
		local object = self.Pool [#self.Pool]
		self.Pool [#self.Pool] = nil
		
		if self.Initializer then
			self.Initializer (object, ...)
		end
		
		return object
	else
		local object = self.Factory (self)
		
		self.TotalSize = self.TotalSize + 1
		
		if self.Initializer then
			self.Initializer (object, ...)
		end
		
		return object
	end
end

function self:Clear ()
	self.TotalSize = self.TotalSize - #self.Pool
	
	if self.Destroyer then
		for i = #self.Pool, 1, -1 do
			self.Destroyer (self.Pool [i])
			self.Pool [i] = nil
		end
	else
		self.Pool = {}
	end
end

function self:Free (object)
	if self.Scrubber then
		self.Scrubber (object)
	end
	
	self.Pool [#self.Pool + 1] = object
end

function self:GetAvailableCount ()
	return #self.Pool
end

function self:GetTotalSize ()
	return self.TotalSize
end

return Pool
