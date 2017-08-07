local self = {}
Glass.Animation = Class (self, Glass.IAnimation)

function self:ctor (t0, updater, ...)
	self.StartTime = t0
	
	self.Updater = updater
	
	self.ArgumentCount, self.Arguments = CompactList.Pack (...)
end

-- IAnimation
function self:GetStartTime ()
	return self.StartTime
end

function self:Update (t)
	local uncompleted = self.Updater (self.StartTime, t, CompactList.Unpack (self.ArgumentCount, self.Arguments))
	return uncompleted == nil and true or uncompleted
end
