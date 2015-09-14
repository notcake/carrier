local self = {}
OOP.Event = OOP.Class (self, OOP.ICloneable)

function self:ctor (instance)
	self.Instance  = instance
	
	self.Description = nil
	
	self.Listeners = {}
end

function self:dtor ()
	self.Instance = nil
	self:ClearListeners ()
end

-- ICloneable
function self:Copy (source)
	for callbackName, callback in pairs (source.Listeners) do
		self:AddListener (callbackName, callback)
	end
	
	return self
end

-- Event
function self:GetInstance ()
	return self.Instance
end

function self:GetDescription ()
	return self.Description
end

function self:SetDescription (description)
	self.Description = description
	return self
end

function self:AddListener (nameOrCallback, callback)
	callback = callback or nameOrCallback
	self.Listeners [nameOrCallback] = callback
end

function self:ClearListeners ()
	if not next (self.Listeners) then return end
	
	self.Listeners = {}
end

function self:Dispatch (...)
	if self.ShouldSuppressEvents then return end
	
	local a, b, c = nil, nil, nil
	
	for callbackName, callback in pairs (self.Listeners) do
		local success, r0, r1, r2 = xpcall (callback, OOP.Error, self.Instance, ...)
		if not success then
			ErrorNoHalt ("Error in hook " .. eventName .. ": " .. tostring (callbackName) .. "!\n")
		else
			a = a or r0
			b = b or r1
			c = c or r2
		end
	end
	
	return a, b, c
end

function self:RemoveListener (nameOrCallback)
	self.Listeners [nameOrCallback] = nil
end

function self:__call (...)
	return self:Dispatch (...)
end