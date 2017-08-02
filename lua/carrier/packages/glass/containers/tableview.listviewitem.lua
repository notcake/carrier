function Glass.TableView.ListViewItem (UI)
	local self = {}
	local ListViewItem = Class (self, UI.ListViewItem)
	
	function self:ctor ()
		self.TableView = nil
		self.TableViewItem = nil
		
		self.ColumnViews     = {}
		self.ColumnViewTypes = {}
		
		self.ColumnLayoutHeight = nil
		self.ColumnLayoutValid  = false
		
		self.ColumnContentValid = false
	end
	
	-- IView
	-- Internal
	function self:OnLayout (w, h)
		-- Update content
		if not self.ColumnContentValid then
			self:UpdateColumns ()
		end
		
		-- Invalidate column layout on height changes
		if self.ColumnLayoutHeight ~= h then
			self.ColumnLayoutValid = false
		end
		
		-- Layout columns
		if not self.ColumnLayoutValid then
			self:LayoutColumns ()
		end
	end
	
	-- ListViewItem
	function self:Bind (tableView, tableViewItem)
		self.TableView = tableView
		self.TableViewItem = tableViewItem
		
		self.TableView:GetColumns ().LayoutChanged:AddListener ("Glass.TableView.ListViewItem." .. self:GetHashCode (), self, self.InvalidateColumnContent)
		self.TableViewItem.Changed:AddListener ("Glass.TableView.ListViewItem." .. self:GetHashCode (), self, self.InvalidateColumnContent)
		self:UpdateColumns ()
		self:InvalidateColumnLayout ()
	end
	
	function self:Unbind ()
		self.TableView:GetColumns ().LayoutChanged:RemoveListener ("Glass.TableView.ListViewItem." .. self:GetHashCode ())
		self.TableViewItem.Changed:RemoveListener ("Glass.TableView.ListViewItem." .. self:GetHashCode ())
		
		self.TableView = nil
		self.TableViewItem = nil
	end
	
	-- Internal
	function self:LayoutColumns ()
		local h = self:GetHeight ()
		self.ColumnLayoutHeight = h
		self.ColumnLayoutValid  = true
		
		local padding = 4
		
		self.TableView:GetHeader ():EnsureColumnLayoutValid ()
		for column in self.TableView:GetColumns ():GetEnumerator () do
			if column:IsVisible () then
				local headerColumnView = self.TableView:GetHeader ():GetColumnView (column)
				local columnView = self.ColumnViews [column:GetId ()]
				local x, _, w, _ = headerColumnView:GetRectangle ()
				columnView:SetRectangle (x + padding, 0, w - padding * 2, h)
			end
		end
	end
	
	function self:InvalidateColumnLayout ()
		self.ColumnLayoutValid = false
		
		self:InvalidateLayout ()
	end
	
	function self:InvalidateColumnContent ()
		self.ColumnContentValid = false
		
		self:InvalidateLayout ()
	end
	
	function self:UpdateColumns ()
		self.ColumnContentValid = true
		
		-- Clean up columns that no longer exist
		for id, columnView in pairs (self.ColumnViews) do
			if not self.TableView:GetColumns ():GetById (id) then
				columnView:dtor ()
				self.ColumnViews [id] = nil
				self.ColumnViewsTypes [id] = nil
			end
		end
		
		-- Update columns
		for column in self.TableView:GetColumns ():GetEnumerator () do
			local id = column:GetId ()
			
			local columnView = self.ColumnViews [id]
			local columnViewType = self.TableViewItem:GetColumnType (id)
			if column:IsVisible () then
				if columnView and self.ColumnViewTypes [id] ~= columnViewType then
					columnView:dtor ()
					columnView = nil
				end
				
				-- Ensure the column view is created
				if not columnView then
					if columnViewType == Glass.TableViewColumnType.None then
						columnView = UI.View ()
					elseif columnViewType == Glass.TableViewColumnType.Text then
						columnView = UI.Label ()
					elseif columnViewType == Glass.TableViewColumnType.CustomRenderer then
						columnView = UI.TableView.ListViewItem.CustomRenderedView ()
					end
					columnView:SetParent (self)
					self.ColumnViews [id] = columnView
					self.ColumnViewTypes [id] = columnViewType
					
					self:InvalidateColumnLayout ()
				end
				
				-- Set up the column view
				if columnViewType == Glass.TableViewColumnType.None then
				elseif columnViewType == Glass.TableViewColumnType.Text then
					columnView:SetText (self.TableViewItem:GetColumnText (id))
					columnView:SetHorizontalAlignment (self.TableViewItem:GetColumnAlignment (column:GetId ()) or column:GetAlignment ())
				elseif columnViewType == Glass.TableViewColumnType.CustomRenderer then
					columnView:SetTableViewItem (self.TableViewItem)
					columnView:SetRenderer (self.TableViewItem:GetColumnRenderer (id))
				end
			else
				if columnView then
					columnView:dtor ()
					self.ColumnViews [column:GetId ()] = nil
					self.ColumnViewTypes [column:GetId ()] = nil
				end
			end
		end
	end
	
	return ListViewItem
end

Glass.TableView.ListViewItem = Table.Callable (Glass.TableView.ListViewItem)
