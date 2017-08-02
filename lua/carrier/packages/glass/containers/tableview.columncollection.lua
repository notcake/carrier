function Glass.TableView.ColumnCollection (UI)
	local self = {}
	local ColumnCollection = Class (self, ICollection)
	
	self.Changed        = Event ()
	self.Cleared        = Event ()
	self.LayoutChanged  = Event ()
	
	self.ColumnAdded    = Event ()
	self.ColumnInserted = Event ()
	self.ColumnRemoved  = Event ()
	
	function self:ctor ()
		self.Columns     = {}
		self.ColumnsById = {}
	end
	
	-- IEnumerable<TableViewColumn>
	function self:GetEnumerator ()
		return ArrayEnumerator (self.Columns)
	end
	
	-- ICollection<TableViewColumn>
	function self:GetCount ()
		return #self.Columns
	end
	
	-- ColumnCollection
	function self:Add (id, name)
		return self:Insert (#self.Columns + 1, id, name)
	end
	
	function self:Clear ()
		if #self.Columns == 0 then return end
		
		for i = #self.Columns, 1, -1 do
			local column = self.Columns [i]
			column.AlignmentChanged:RemoveListener ("Glass.TableView.ColumnCollection." .. self:GetHashCode ())
			column.WidthChanged    :RemoveListener ("Glass.TableView.ColumnCollection." .. self:GetHashCode ())
			column.VisibleChanged  :RemoveListener ("Glass.TableView.ColumnCollection." .. self:GetHashCode ())
			
			self.Columns [i] = nil
		end
		
		self.ColumnsCleared:Dispatch ()
		self.LayoutChanged:Dispatch ()
		self.Changed:Dispatch ()
	end
	
	function self:Get (i)
		return self.Columns [i]
	end
	
	function self:GetById (id)
		return self.ColumnsById [id]
	end
	
	function self:Insert (i, id, name)
		local i = math.min (#self.Columns + 1, math.max (1, i))
		local column = Glass.TableViewColumn (id, name)
		table.insert (self.Columns, i, column)
		self.ColumnsById [id] = column
		
		column.AlignmentChanged:AddListener ("Glass.TableView.ColumnCollection." .. self:GetHashCode (), self, self.DispatchLayoutChanged)
		column.WidthChanged    :AddListener ("Glass.TableView.ColumnCollection." .. self:GetHashCode (), self, self.DispatchLayoutChanged)
		column.VisibleChanged  :AddListener ("Glass.TableView.ColumnCollection." .. self:GetHashCode (), self, self.DispatchLayoutChanged)
		
		if i == #self.Columns then
			self.ColumnAdded:Dispatch (column)
		else
			self.ColumnInserted:Dispatch (i, column)
		end
		self.LayoutChanged:Dispatch ()
		self.Changed:Dispatch ()
		
		return column
	end
	
	function self:Remove (iOrColumn)
		local i = iOrColumn
		if not self.Columns [iOrColumn] then
			i = self:IndexOf (iOrColumn)
			if not i then return end
		end
		
		local column = self.Columns [i]
		table.remove (self.Columns, i)
		
		column.WidthChanged  :RemoveListener ("Glass.TableView.ColumnCollection." .. self:GetHashCode ())
		column.VisibleChanged:RemoveListener ("Glass.TableView.ColumnCollection." .. self:GetHashCode ())
		
		self.ColumnRemoved:Dispatch (i, column)
		self.LayoutChanged:Dispatch ()
		self.Changed:Dispatch (i, column)
	end
	
	-- Internal
	function self:DispatchLayoutChanged ()
		self.LayoutChanged:Dispatch ()
	end
	
	return ColumnCollection
end
