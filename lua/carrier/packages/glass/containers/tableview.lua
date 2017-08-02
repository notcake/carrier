function Glass.TableView (UI)
	local self = {}
	local TableView = Class (self, UI.View)
	TableView.ListViewItem                    = Glass.TableView.ListViewItem (UI)
	TableView.ListViewItem.CustomRenderedView = Glass.TableView.ListViewItem.CustomRenderedView (UI)
	TableView.InternalDataSource              = Glass.TableView.InternalDataSource (UI)
	TableView.Header                          = Glass.TableView.Header (UI)
	TableView.ColumnView                      = Glass.TableView.ColumnView (UI)
	TableView.ColumnResizeGrip                = Glass.TableView.ColumnResizeGrip (UI)
	TableView.ColumnCollection                = Glass.TableView.ColumnCollection (UI)
	
	function self:ctor ()
		self.Columns = TableView.ColumnCollection ()
		
		self.ListView = UI.ListView ()
		self.ListView:SetParent (self)
		
		self.DataSource = TableView.InternalDataSource (self)
		self.ListView:SetDataSource (self.DataSource)
		
		self.Header = TableView.Header (self)
		self.ListView:SetHeader (self.Header)
		
		self.Header.TotalWidthChanged:AddListener (
			function (totalWidth)
				self.ListView:SetItemWidth (totalWidth)
			end
		)
		self.ListView:SetItemWidth (self.Header:GetTotalWidth ())
	end
	
	function self:dtor ()
		self.DataSource:dtor ()
	end
	
	-- IView
	-- Internal
	function self:OnLayout (w, h)
		self.ListView:SetRectangle (0, 0, w, h)
	end
	
	-- TableView
	function self:Clear ()
		self.Columns:Clear ()
		self:ClearItems ()
	end
	
	function self:GetRowHeight ()
		return self.DataSource:GetRowHeight ()
	end
	
	function self:SetRowHeight (rowHeight)
		self.DataSource:SetRowHeight (rowHeight)
	end
	
	-- Columns
	function self:GetColumns ()
		return self.Columns
	end
	
	-- Items
	function self:AddItem (tableViewItem)
		self.DataSource:AddItem (tableViewItem)
	end
	
	function self:ClearItems ()
		self.DataSource:ClearItems ()
	end
	
	function self:GetItem (i)
		return self.DataSource:GetItemLazy (i)
	end
	
	function self:GetItemCount ()
		return self.DataSource:GetItemCount ()
	end
	
	function self:InsertItem (index, tableViewItem)
		self.DataSource:InsertItem (index, tableViewItem)
	end
	
	function self:RemoveItem (index)
		self.DataSource:RemoveItem (index)
	end
	
	-- Data Source
	function self:GetDataSource ()
		return self.DataSource:GetDataSource ()
	end
	
	function self:SetDataSource (dataSource)
		self.DataSource:SetDataSource (dataSource)
	end
	
	-- Internal
	function self:GetHeader ()
		return self.Header
	end
	
	return TableView
end

Glass.TableView = Table.Callable (Glass.TableView)
