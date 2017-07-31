function Glass.TreeTableView (UI)
	local self = {}
	local TreeTableView = Class (self, UI.View)
	
	function self:ctor ()
		self.TableView = UI.TableView ()
		self.TableView:SetParent (self)
	end
	
	-- IView
	-- Internal
	function self:OnLayout (w, h)
		self.TableView:SetRectangle (0, 0, w, h)
	end
	
	-- TreeTableView
	function self:Clear ()
		self.TableView:Clear ()
		self:ClearItems ()
	end
	
	function self:GetRowHeight ()
		return self.TableView:GetRowHeight ()
	end
	
	function self:SetRowHeight (rowHeight)
		self.TableView:SetRowHeight (rowHeight)
	end
	
	-- Columns
	function self:GetColumns ()
		return self.TableView:GetColumns ()
	end
	
	-- Items
	function self:AddItem (tableViewItem)
		self.TableView:AddItem (tableViewItem)
	end
	
	function self:ClearItems ()
		self.TableView:ClearItems ()
	end
	
	return TreeTableView
end
