local self = {}
Scrollbar = Class (self, GarrysMod.View)

function self:ctor ()
	self.ContentSize = 0
	self.ViewSize    = 1
end

-- IView
-- Content layout

-- Scrollbar
-- Metrics
function self:GetOrientation ()
	Error ("Scrollbar:GetOrientation : Not implemented.")
end

function self:GetThickness ()
	return GarrysMod.Skin.Default.Metrics.ScrollbarThickness
end

-- Content
function self:GetContentSize ()
	return self.ContentSize
end

function self:GetViewSize ()
	return self.ViewSize
end

function self:SetContentSize (contentSize)
	if self.ContentSize == contentSize then return end
	
	self.ContentSize = contentSize
end

function self:SetViewSize (viewSize)
	if self.ViewSize == viewSize then return end
	
	self.ViewSize = viewSize
end
