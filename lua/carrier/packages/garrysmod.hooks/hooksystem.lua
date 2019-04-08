local self = {}
HookSystem = Interface(self)

function self:ctor()
	self.PreHooks  = {}
	self.Hooks     = {}
	self.PostHooks = {}
	
	self.InstalledPrePostHooks = {}
	self.PreHookName  = "GarrysMod.Hooks.\xcf\xa3\xce\x92"
	self.PostHookName = "GarrysMod.Hooks.\x95\x1d\xe5\x4c"
end

function self:dtor()
	for eventName, _ in pairs(self.InstalledPrePostHooks) do
		self:RemovePrePostHook(eventName)
	end
end

function self:AddPreHook(eventName, id, f)
	if not f then self:RemovePreHook(eventName, id) return end
	
	local isFirstHook = self:Add(self.PreHooks, eventName, id, f)
	if isFirstHook then
		self:UpdatePrePostHook(eventName)
	end
end

function self:AddHook(eventName, id, f)
	if not f then self:RemoveHook(eventName, id) return end
	
	self:Add(self.Hooks, eventName, id, f)
	hook.Add(eventName, id, f)
end

function self:AddPostHook(eventName, id, f)
	if not f then self:RemovePostHook(eventName, id) return end
	
	local isFirstHook = self:Add(self.PostHooks, eventName, id, f)
	if isFirstHook then
		self:UpdatePrePostHook(eventName)
	end
end

function self:RemovePreHook(eventName, id)
	local wasLastHook = self:Remove(self.PreHooks, eventName, id)
	if wasLastHook then
		self:UpdatePrePostHook(eventName)
	end
end

function self:RemoveHook(eventName, id)
	self:Remove(self.Hooks, eventName, id)
	hook.Remove(eventName, id)
end

function self:RemovePostHook(eventName, id)
	local wasLastHook = self:Remove(self.PostHooks, eventName, id)
	if wasLastHook then
		self:UpdatePrePostHook(eventName)
	end
end

-- Internal
function self:Add(hookTable, eventName, id, f)
	if not f then return false end
	
	hookTable[eventName] = hookTable[eventName] or {}
	local isFirstHook = next(hookTable[eventName]) == nil
	hookTable[eventName][id] = f
	
	return isFirstHook
end

function self:Remove(hookTable, eventName, id)
	if not hookTable[eventName] then return false end
	
	hookTable[eventName][id] = nil
	
	return next(hookTable[eventName]) == nil
end

function self:Dispatch(hookTable, eventName, ...)
	if not hookTable[eventName] then return end
	
	for _, f in pairs(hookTable[eventName]) do
		f(...)
	end
end

function self:UpdatePrePostHook(eventName)
	local needsHook = (self.PreHooks [eventName] and next(self.PreHooks [eventName]) ~= nil) or
	                  (self.PostHooks[eventName] and next(self.PostHooks[eventName]) ~= nil)
	if needsHook == (self.InstalledPrePostHooks[eventName] or false) then return end
	
	if needsHook then
		self:AddPrePostHook(eventName)
	else
		self:RemovePrePostHook(eventName)
	end
end

function self:AddPrePostHook(eventName)
	hook.Add(eventName, self.PreHookName,
		function(...)
			self:Dispatch(self.PreHooks, eventName, ...)
		end
	)
	hook.Add(eventName, self.PostHookName,
		function(...)
			self:Dispatch(self.PostHooks, eventName, ...)
			
			if self.InstalledPrePostHooks[eventName] and
			   next(hook.GetTable() [eventName]) ~= self.PreHookName then
				self:AssertPrePostHook(eventName)
			end
		end
	)
	
	local hookTable = hook.GetTable() [eventName]
	if next(hookTable) ~= self.PreHookName then
		self:AssertPrePostHook(eventName)
	end
	
	self.InstalledPrePostHooks[eventName] = true
end

function self:AssertPrePostHook(eventName)
	local hookTable = hook.GetTable() [eventName]
	
	local count = 0
	local hookTableCopy = {}
	
	for id, f in pairs(hookTable) do
		hookTableCopy[id] = f
		hookTable[id] = nil
		count = count + 1
	end
		
	for i = 1, count * 2 do
		hookTable[i] = nil
	end

	hookTable[self.PreHookName]  = hookTableCopy[self.PreHookName]
	hookTable[self.PostHookName] = hookTableCopy[self.PostHookName]
	for id, f in pairs(hookTableCopy) do
		hookTable[id] = f
	end
end

function self:RemovePrePostHook(eventName)
	hook.Remove(eventName, self.PreHookName)
	hook.Remove(eventName, self.PostHookName)
	
	self.InstalledPrePostHooks[eventName] = nil
end
