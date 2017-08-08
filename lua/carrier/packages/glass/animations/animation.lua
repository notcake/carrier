local self = {}
Glass.Animation = Interface (self, Glass.IAnimation)

function self:ctor (t0, updater)
	self.Completed = false
	self.Updater   = updater
	
	self.StartTime = t0
end

-- IAnimation
function self:IsCompleted ()
	return self.Completed
end

function self:Update (t)
	local uncompleted = self.Updater (t0, t)
	if uncompleted == nil then uncompleted = true end
	
	self.Completed = not uncompleted
	
	return not self.Completed
end
