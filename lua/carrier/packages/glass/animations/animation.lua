local self = {}
Glass.Animation = Class (self, Glass.IAnimation)

function self:ctor (t0, updater, ...)
	self.StartTime = t0
	
	self.Completed = false
	
	self.Updater = updater
	
	self.ArgumentCount, self.Arguments = CompactList.Pack (...)
end

-- IAnimation
function self:GetStartTime ()
	return self.StartTime
end

function self:IsCompleted ()
	return self.Completed
end

function self:Update (t)
	local uncompleted = self.Updater (self.StartTime, t, CompactList.Unpack (self.ArgumentCount, self.Arguments))
	
	if uncompleted == false then
		self.Completed = true
	end
	
	return not self.Completed
end
