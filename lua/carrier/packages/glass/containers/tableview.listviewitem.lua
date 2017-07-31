function TableView.ListViewItem (UI)
	local self = {}
	local ListViewItem = Class (self, UI.ListViewItem)
	
	function self:ctor ()
		self.TableViewItem = nil
	end
	
	-- IView
	-- Internal
	function self:Render (w, h, render2d)
		render2d:FillRectangle (Colors.Red, 0, 0, w, h)
	end
	
	-- ListViewItem
	function self:Bind (tableViewItem)
		self.TableViewItem = tableViewItem
	end
	
	function self:Unbind ()
		self.TableViewItem = nil
	end
	
	return ListViewItem
end
