local self = {}
OOP.Event = OOP.Class (self, OOP.ICloneable)

function self:ctor (name)
	self.Name = name
	
	self.Locked    = 0
	self.Listeners = {}
end

-- ICloneable
function self:Copy (source)
	self.Name = source.Name
	
	if next (self.Listeners) then
		self:ClearListeners ()
	end
	
	for callbackName, callback in pairs (source.Listeners) do
		self:AddListener (callbackName, callback)
	end
	
	return self
end

-- Event
function self:GetInstanceId ()
	return self.InstanceId
end

function self:GetName ()
	return self.Name
end

function self:SetName (name)
	self.Name = name
	return self
end

function self:AddListener (nameOrCallback, callback1, callback2)
	local callback = callback1 or nameOrCallback
	
	-- Copy on contention
	if self.Locked > 0 then
		self.Listeners = Table.ShallowCopy (self.Listeners)
	end
	
	-- Member function autoclosures
	if callback2 then
		local object = callback1
		local method = callback2
		callback = function (...)
			method (object, ...)
		end
	end
	
	self.Listeners [nameOrCallback] = callback
end

function self:ClearListeners ()
	if not next (self.Listeners) then return end
	
	self.Listeners = {}
end

function self:Dispatch (...)
	self.Locked = self.Locked + 1
	for callbackName, callback in pairs (self.Listeners) do
		local success = xpcall (callback, ErrorNoHalt, ...)
		if not success then
			ErrorNoHalt ("Error in event " .. self.Name .. " listener: " .. tostring (callbackName) .. "!\n")
		end
	end
	self.Locked = self.Locked - 1
end

function self:RemoveListener (nameOrCallback)
	self.Listeners [nameOrCallback] = nil
end

function self:__call (...)
	return self:Dispatch (...)
end
