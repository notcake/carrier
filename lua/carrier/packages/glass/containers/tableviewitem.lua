function Glass.TableViewItem (UI)
	local self = {}
	local TableViewItem = Class (self)
	
	self.Changed = Event ()
	
	function self:ctor (text)
		self.Text = text
		
		self.ColumnTypes      = {}
		self.Columns          = {}
		self.ColumnAlignments = {}
	end

	function self:GetText ()
		return self.Text
	end

	function self:GetColumnText (id)
		if self.ColumnTypes [id] == Glass.TableViewColumnType.Text then
			return self.Columns [id]
		else
			return nil
		end
	end

	function self:GetColumnAlignment (id)
		return self.ColumnAlignments [id]
	end

	function self:SetText (text)
		self.Text = text
		
		self.Changed:Dispatch ()
	end

	function self:SetColumnText (id, text)
		self.ColumnTypes [id] = Glass.TableViewColumnType.Text
		self.Columns [id] = text
		
		self.Changed:Dispatch ()
	end

	function self:SetColumnAlignment (id, alignment)
		self.ColumnAlignments [id] = alignment
		
		self.Changed:Dispatch ()
	end
	
	return TableViewItem
end
