local self = {}
Glass.TableViewColumn = Class(self)

self.Changed          = Event()

self.NameChanged      = Event()
self.AlignmentChanged = Event()
self.VisibleChanged   = Event()
self.WidthChanged     = Event()

function self:ctor(id, name)
	self.Id           = id
	self.Name         = name or id
	
	self.MinimumWidth = 32
	
	self.Visible      = true
	self.Alignment    = Glass.HorizontalAlignment.Left
	self.Width        = 128
end

function self:GetId()
	return self.Id
end

function self:GetName()
	return self.Name
end

function self:GetMinimumWidth()
	return self.MinimumWidth
end

function self:GetAlignment()
	return self.Alignment
end

function self:GetWidth()
	return self.Width
end

function self:IsVisible()
	return self.Visible
end

function self:SetName(name)
	if self.Name == name then return end
	
	self.Name = name
	
	self.NameChanged:Dispatch(self.Name)
	self.Changed:Dispatch()
end

function self:SetMinimumWidth(minimumWidth)
	if self.MinimumWidth == minimumWidth then return end
	
	self.MinimumWidth = minimumWidth
	
	self.Changed:Dispatch()
end

function self:SetAlignment(horizontalAlignment)
	if self.Alignment == horizontalAlignment then return end
	
	self.Alignment = horizontalAlignment
	
	self.AlignmentChanged:Dispatch(self.Alignment)
	self.Changed:Dispatch()
end

function self:SetWidth(width)
	local width = math.max(0, width)
	
	if self.Width == width then return end
	
	self.Width = width
	
	self.WidthChanged:Dispatch(self.Width)
	self.Changed:Dispatch()
end

function self:SetVisible(visible)
	if self.Visible == visible then return end
	
	self.Visible = visible
	
	self.VisibleChanged:Dispatch(self.Visible)
	self.Changed:Dispatch()
end
