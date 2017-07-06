local self = {}
ExternalView = Class (self, GarrysMod.View)

function self:ctor (panel)
	self.Panel = panel
	
	PanelViews.Register (panel, self)
end
