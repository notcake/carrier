local self = {}
Glass.TableView.Header = Class(self, Glass.View)

self.TotalWidthChanged = Event()

function self:ctor(tableView)
	self.ListenerName = "Glass.TableView.Header." .. self:GetHashCode()
	
	self.TableView = tableView
	
	self.ColumnViews       = {}
	self.ColumnResizeGrips = {}
	
	self.TotalWidth = 0
	
	self.GripZOrderValid    = false
	self.ColumnLayoutHeight = nil
	self.ColumnLayoutValid  = false
	
	self.TableView:GetColumns().Cleared       :AddListener(self.ListenerName, self, self.UpdateColumns)
	self.TableView:GetColumns().ColumnAdded   :AddListener(self.ListenerName, self, self.CreateColumnViews)
	self.TableView:GetColumns().ColumnInserted:AddListener(self.ListenerName, self, self.CreateColumnViews)
	self.TableView:GetColumns().ColumnRemoved :AddListener(self.ListenerName, self, self.DestroyColumnViews)
	self:UpdateColumns()
end

function self:dtor()
	self.TableView:GetColumns().Cleared       :RemoveListener(self.ListenerName)
	self.TableView:GetColumns().ColumnAdded   :RemoveListener(self.ListenerName)
	self.TableView:GetColumns().ColumnInserted:RemoveListener(self.ListenerName)
	self.TableView:GetColumns().ColumnRemoved :RemoveListener(self.ListenerName)
	
	for column, columnView in pairs(self.ColumnViews) do
		self:DestroyColumnViews(column)
	end
end

-- IView
-- Content layout
function self:GetPreferredSize(maximumWidth, maximumHeight)
	return self.TotalWidth, 24
end

-- Internal
function self:OnLayout(w, h)
	-- Bring resize grips to front
	if not self.GripZOrderValid then
		self:LayoutGripZOrder()
	end
	
	-- Invalidate column layout on height changes
	if self.ColumnLayoutHeight ~= h then
		self.ColumnLayoutValid = false
	end
	
	-- Layout columns
	self:EnsureColumnLayoutValid()
	if not self.ColumnLayoutValid then
		self:LayoutColumns()
	end
end

function self:Render(w, h, render2d)
	render2d:FillRectangle(self:GetSkin():GetBackgroundColor(), 0, 0, w, h)
	
	for column in self.TableView:GetColumns():GetEnumerator() do
		if column:IsVisible() then
			local columnView = self.ColumnViews[column]
			local x = columnView:GetX() + columnView:GetWidth()
			render2d:DrawLine(Color.LightGray, x, -0.5, x, h)
		end
	end
end

-- Header
function self:GetTableView()
	return self.TableView
end

function self:GetTotalWidth()
	return self.TotalWidth
end

function self:GetColumnView(column)
	return self.ColumnViews[column]
end

function self:EnsureColumnLayoutValid()
	if self.ColumnLayoutValid then return end
	
	self:LayoutColumns()
end

-- Internal
function self:LayoutGripZOrder()
	self.GripZOrderValid = true
	
	for _, columnResizeGrip in pairs(self.ColumnResizeGrips) do
		columnResizeGrip:BringToFront()
	end
end

function self:LayoutColumns()
	local h = self:GetHeight()
	
	self.ColumnLayoutHeight = h
	self.ColumnLayoutValid  = true
	
	local x = 0
	for column in self.TableView:GetColumns():GetEnumerator() do
		local columnView       = self.ColumnViews      [column]
		local columnResizeGrip = self.ColumnResizeGrips[column]
		
		columnView:SetRectangle(x, 0, column:GetWidth(), h)
		columnView:SetVisible(column:IsVisible())
		columnResizeGrip:SetVisible(column:IsVisible())
		if column:IsVisible() then
			x = x + column:GetWidth()
			x = x + 1
		end
		columnResizeGrip:SetRectangle(x - 1 - 4, 0, 4 + 1 + 4, h)
	end
	
	self:SetTotalWidth(x)
end

function self:InvalidateGripZOrder()
	self.GripZOrderValid = false
	
	self:InvalidateLayout()
end

function self:InvalidateColumnLayout()
	self.ColumnLayoutValid = false
	
	self:InvalidateLayout()
end

function self:SetTotalWidth(totalWidth)
	if self.TotalWidth == totalWidth then return end
	
	self.TotalWidth = totalWidth
	
	self.TotalWidthChanged:Dispatch(self.TotalWidth)
end

function self:UpdateColumns()
	local columnSet = {}
	for column in self.TableView:GetColumns():GetEnumerator() do
		columnSet[column] = true
		if not self.ColumnViews[column] then
			self:CreateColumnViews(column)
		end
	end
	
	for column, columnView in pairs(self.ColumnViews) do
		if not columnSet[column] then
			self:DestroyColumnViews(column)
		end
	end
end

function self:CreateColumnViews(column)
	local columnView = Glass.TableView.ColumnView(column)
	columnView:SetParent(self)
	local columnResizeGrip = Glass.TableView.ColumnResizeGrip(column)
	columnResizeGrip:SetParent(self)
	
	column.WidthChanged  :AddListener(self.ListenerName, self, self.InvalidateColumnLayout)
	column.VisibleChanged:AddListener(self.ListenerName, self, self.InvalidateColumnLayout)
	
	self.ColumnViews[column] = columnView
	self.ColumnResizeGrips[column] = columnResizeGrip
	
	self:InvalidateGripZOrder()
	self:InvalidateColumnLayout()
	
	return columnView, columnResizeGrip
end

function self:DestroyColumnViews(column)
	column.WidthChanged  :RemoveListener(self.ListenerName)
	column.VisibleChanged:RemoveListener(self.ListenerName)
	
	self.ColumnViews[column]:dtor()
	self.ColumnViews[column] = nil
	
	self.ColumnResizeGrips[column]:dtor()
	self.ColumnResizeGrips[column] = nil
	
	self:InvalidateColumnLayout()
end
