local self = {}
ExternalView = Class (self, GarrysMod.View)

function self:ctor (panel)
	self.Handle = panel
	
	GarrysMod.Environment:RegisterView (panel, self)
end
