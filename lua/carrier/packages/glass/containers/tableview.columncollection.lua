function TableView.ColumnCollection (UI)
	local self = {}
	local ColumnCollection = Class (self, ICollection)
	
	self.Changed        = Event ()
	self.Cleared        = Event ()
	
	self.ColumnAdded    = Event ()
	self.ColumnInserted = Event ()
	self.ColumnRemoved  = Event ()
	
	function self:ctor ()
		self.Columns = {}
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
	function self:Add (name)
		local column = Glass.TableViewColumn (name)
		self.Columns [#self.Columns + 1] = column
		
		self.ColumnAdded:Dispatch (column)
		self.Changed:Dispatch ()
		
		return column
	end
	
	function self:Clear ()
		if #self.Columns == 0 then return end
		
		self.Columns = {}
		
		self.ColumnsCleared:Dispatch ()
		self.Changed:Dispatch ()
	end
	
	function self:Get (i)
		return self.Columns [i]
	end
	
	function self:Insert (i, name)
		local i = math.min (#self.Columns + 1, math.max (1, i))
		local column = Glass.TableViewColumn (name)
		table.insert (self.Columns, i, column)
		
		self.ColumnInserted:Dispatch (i, column)
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
		
		self.ColumnRemoved:Dispatch (i, column)
		self.Changed:Dispatch (i, column)
	end
	
	return ColumnCollection
end
