local self = {}
Util.Autosaver = Class(self, Util.ISavable)

function self:ctor(savable)
	self.Savable                = savable
	
	self.Enabled                = true
	
	self.SaveNeededStartTime    = 0
	self.SaveNeeded             = false
	
	self.SaveDelay              =  5 -- Delay between invalidation and a write
	self.SaveInterval           = 30 -- Maximum duration a write can be pushed back
	self.LastSaveTime           = SysTime()
	self.TimerCreated           = false
	
	self.InvalidationSuppressed = 0
	
	self.ChangeListenables      = WeakKeyTable()
end

function self:dtor()
	if not self:IsEnabled() then return end
	
	if self:IsSaveNeeded() then
		self:Save()
	end
	
	self:DestroyTimer()
end

-- ISavable
function self:Save()
	self:Validate()
	
	self.Savable:Save()
end

function self:Load()
	self:SuppressInvalidation()
	self.Savable:Load()
	self:UnsuppressInvalidation()
end

-- Autosaver
function self:IsEnabled()
	return self.Enabled
end

function self:SetEnabled(enabled)
	if self.Enabled == enabled then return end
	
	self.Enabled = enabled
	
	if self.Enabled then
		if self:IsSaveNeeded() then
			self:CreateTimer()
		end
	else
		self:DestroyTimer()
	end
end

function self:RegisterChild(object)
	self.ChangeListenables[object] = true
	self:AddChangeListeners(object)
end

function self:UnregisterChild(object)
	self.ChangeListenables[object] = nil
	self:RemoveChangeListeners(object)
end

function self:Invalidate()
	if self.InvalidationSuppressed > 0 then return end
	
	if self.SaveNeeded then
		if not self:IsEnabled() then return end
		
		if SysTime() - self.SaveNeededStartTime + self.SaveDelay < self.SaveInterval then
			-- Delay save unless it's already been delayed for too long
			self:DelayTimer()
		end
	else
		self.SaveNeeded = true
		self.SaveNeededStartTime = SysTime()
		
		if not self:IsEnabled() then return end
		self:CreateTimer()
	end
end

function self:Validate()
	if not self.SaveNeeded then return end
	
	self.SaveNeeded = false
	self:DestroyTimer()
end

function self:IsSaveNeeded()
	return self.SaveNeeded
end

function self:SuppressInvalidation()
	self.InvalidationSuppressed = self.InvalidationSuppressed + 1
end

function self:UnsuppressInvalidation()
	self.InvalidationSuppressed = self.InvalidationSuppressed - 1
end

-- Internal
-- Timer
function self:CreateTimer()
	if self.TimerCreated then return end
	
	self.TimerCreated = true
	
	timer.Create("Autosaver." .. self:GetHashCode(), self.SaveDelay, 1,
		function()
			self:Save()
		end
	)
end

function self:DelayTimer()
	if not self.TimerCreated then return end
	
	timer.Adjust("Autosaver." .. self:GetHashCode(), self.SaveDelay, 1,
		function()
			self:Save()
			self:DestroyTimer()
		end
	)
end

function self:DestroyTimer()
	if not self.TimerCreated then return end
	
	self.TimerCreated = false
	
	timer.Destroy("Autosaver." .. self:GetHashCode())
end

-- Change listeners
function self:AddChangeListeners(object)
	if not object then return end
	
	object.Changed:AddListener("Autosaver." .. self:GetHashCode(),
		function()
			self:Invalidate()
		end
	)
end

function self:RemoveChangeListeners(object)
	if not object then return end
	
	object.Changed:RemoveListener("Autosaver." .. self:GetHashCode())
end
