function TableView.ListViewItem (UI)
	local self = {}
	local ListViewItem = Class (self, UI.ListViewItem)
	
	function self:ctor ()
		self.TableView = nil
		self.TableViewItem = nil
		
		self.ColumnViews = {}
		
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
		
		for column in self.TableView:GetColumns ():GetEnumerator () do
			local columnView = self.ColumnViews [column:GetId ()]
			if column:IsVisible () then
				if not columnView then
					columnView = UI.Label ()
					columnView:SetParent (self)
					self.ColumnViews [column:GetId ()] = columnView
					
					self:InvalidateColumnLayout ()
				end
				
				columnView:SetText (self.TableViewItem:GetColumnText (column:GetId ()) or "")
				columnView:SetHorizontalAlignment (self.TableViewItem:GetColumnAlignment (column:GetId ()) or column:GetAlignment ())
			else
				if columnView then
					columnView:dtor ()
					self.ColumnViews [column:GetId ()] = nil
				end
			end
		end
	end
	
	return ListViewItem
end
