function TableView.Header (UI)
	local self = {}
	local Header = Class (self, UI.View)
	
	self.TotalWidthChanged = Event ()
	
	function self:ctor (tableView)
		self.TableView = tableView
		
		self.ColumnViews = {}
		self.TotalWidth = 0
		
		self.TableView:GetColumns ().Changed:AddListener ("Glass.TableView.Header." .. self:GetHashCode (), self, self.UpdateColumns)
		self:UpdateColumns ()
	end
	
	function self:dtor ()
		self.TableView:GetColumns ().Changed:RemoveListener ("Glass.TableView.Header." .. self:GetHashCode ())
		
		for column, columnView in pairs (self.ColumnViews) do
			self:DestroyColumnView (column, columnView)
			self.ColumnViews [column] = nil
		end
	end
	
	-- IView
	-- Content layout
	function self:GetPreferredSize (maximumWidth, maximumHeight)
		return self.TotalWidth, 24
	end
	
	-- Internal
	function self:OnLayout (w, h)
		self:LayoutColumns ()
	end
	
	function self:Render (w, h, render2d)
		for column in self.TableView:GetColumns ():GetEnumerator () do
			if column:IsVisible () then
				local columnView = self.ColumnViews [column]
				local x = columnView:GetX () + columnView:GetWidth ()
				render2d:DrawLine (Color.LightGray, x, 0, x, h)
			end
		end
	end
	
	-- Header
	function self:GetTableView ()
		return self.TableView
	end
	
	function self:GetTotalWidth ()
		return self.TotalWidth
	end
	
	-- Internal
	function self:LayoutColumns ()
		local h = self:GetHeight ()
		local x = 0
		for column in self.TableView:GetColumns ():GetEnumerator () do
			local columnView = self.ColumnViews [column]
			columnView:SetRectangle (x, 0, column:GetWidth (), h)
			columnView:SetVisible (column:IsVisible ())
			if column:IsVisible () then
				x = x + column:GetWidth ()
				x = x + 1
			end
		end
		
		self:SetTotalWidth (x)
	end
	
	function self:SetTotalWidth (totalWidth)
		if self.TotalWidth == totalWidth then return end
		
		self.TotalWidth = totalWidth
		
		self.TotalWidthChanged:Dispatch (self.TotalWidth)
	end
	
	function self:UpdateColumns ()
		local layoutNeeded = false
		local columnSet = {}
		for column in self.TableView:GetColumns ():GetEnumerator () do
			columnSet [column] = true
			if not self.ColumnViews [column] then
				self.ColumnViews [column] = self:CreateColumnView (column)
				layoutNeeded = true
			end
		end
		
		for column, columnView in pairs (self.ColumnViews) do
			if not columnSet [column] then
				self:DestroyColumnView (column, columnView)
				self.ColumnViews [column] = nil
				layoutNeeded = true
			end
		end
		
		if layoutNeeded then
			self:LayoutColumns ()
		end
	end
	
	function self:CreateColumnView (column)
		local columnView = UI.TableView.ColumnView (column)
		columnView:SetParent (self)
		
		column.WidthChanged  :AddListener ("Glass.TableView.Header." .. self:GetHashCode (), self, self.LayoutColumns)
		column.VisibleChanged:AddListener ("Glass.TableView.Header." .. self:GetHashCode (), self, self.LayoutColumns)
		
		return columnView
	end
	
	function self:DestroyColumnView (column, columnView)
		column.WidthChanged  :RemoveListener ("Glass.TableView.Header." .. self:GetHashCode ())
		column.VisibleChanged:RemoveListener ("Glass.TableView.Header." .. self:GetHashCode ())
		
		columnView:dtor ()
	end
	
	return Header
end
