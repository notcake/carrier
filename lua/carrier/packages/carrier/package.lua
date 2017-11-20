local self = {}
Carrier.Package = Class (self)

function self:ctor (name)
	self.Name         = name
	
	self.Releases     = {}
	self.ReleaseCount = 0
end
