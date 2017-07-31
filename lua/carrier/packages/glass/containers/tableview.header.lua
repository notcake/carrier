function TableView.Header (UI)
	local self = {}
	local Header = Class (self, UI.View)
	
	self.TotalWidthChanged = Event ()
	
	function self:ctor (tableView)
		self.TableView = tableView
		
		self.ColumnViews       = {}
		self.ColumnResizeGrips = {}
		
		self.TotalWidth = 0
		
		self.NeedsOrderingUpdate = false
		
		self.TableView:GetColumns ().Changed:AddListener ("Glass.TableView.Header." .. self:GetHashCode (), self, self.UpdateColumns)
		self:UpdateColumns ()
	end
	
	function self:dtor ()
		self.TableView:GetColumns ().Changed:RemoveListener ("Glass.TableView.Header." .. self:GetHashCode ())
		
		for column, columnView in pairs (self.ColumnViews) do
			self:DestroyColumnViews (column)
		end
	end
	
	-- IView
	-- Content layout
	function self:GetPreferredSize (maximumWidth, maximumHeight)
		return self.TotalWidth, 24
	end
	
	-- Internal
	function self:OnLayout (w, h)
		if self.NeedsOrderingUpdate then
			for _, columnResizeGrip in pairs (self.ColumnResizeGrips) do
				columnResizeGrip:BringToFront ()
			end
			self.NeedsOrderingUpdate = false
		end
		
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
			local columnView       = self.ColumnViews       [column]
			local columnResizeGrip = self.ColumnResizeGrips [column]
			
			columnView:SetRectangle (x, 0, column:GetWidth (), h)
			columnView:SetVisible (column:IsVisible ())
			columnResizeGrip:SetVisible (column:IsVisible ())
			if column:IsVisible () then
				x = x + column:GetWidth ()
				x = x + 1
			end
			columnResizeGrip:SetRectangle (x - 1 - 4, 0, 4 + 1 + 4, h)
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
				self:CreateColumnViews (column)
				layoutNeeded = true
			end
		end
		
		for column, columnView in pairs (self.ColumnViews) do
			if not columnSet [column] then
				self:DestroyColumnViews (column)
				layoutNeeded = true
			end
		end
		
		if layoutNeeded then
			self:LayoutColumns ()
		end
	end
	
	function self:CreateColumnViews (column)
		local columnView = UI.TableView.ColumnView (column)
		columnView:SetParent (self)
		local columnResizeGrip = UI.TableView.ColumnResizeGrip (column)
		columnResizeGrip:SetParent (self)
		
		column.WidthChanged  :AddListener ("Glass.TableView.Header." .. self:GetHashCode (), self, self.LayoutColumns)
		column.VisibleChanged:AddListener ("Glass.TableView.Header." .. self:GetHashCode (), self, self.LayoutColumns)
		
		self.ColumnViews [column] = columnView
		self.ColumnResizeGrips [column] = columnResizeGrip
		
		self.NeedsOrderingUpdate = true
		
		return columnView, columnResizeGrip
	end
	
	function self:DestroyColumnViews (column)
		column.WidthChanged  :RemoveListener ("Glass.TableView.Header." .. self:GetHashCode ())
		column.VisibleChanged:RemoveListener ("Glass.TableView.Header." .. self:GetHashCode ())
		
		self.ColumnViews [column]:dtor ()
		self.ColumnViews [column] = nil
		
		self.ColumnResizeGrips [column]:dtor ()
		self.ColumnResizeGrips [column] = nil
	end
	
	return Header
end
