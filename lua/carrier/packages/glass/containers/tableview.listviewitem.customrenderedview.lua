function Glass.TableView.ListViewItem.CustomRenderedView (UI)
	local self = {}
	local CustomRenderedView = Class (self, UI.View)
	
	function self:ctor ()
		self.TableViewItem = nil
		self.Renderer = nil
	end
	
	-- IView
	-- Internal
	function self:Render (w, h, render2d)
		if self.Renderer then
			self.Renderer (self.TableViewItem, w, h, render2d)
		end
	end
	
	-- CustomRenderedView
	function self:GetTableViewItem ()
		return self.TableViewItem
	end
	
	function self:GetRenderer ()
		return self.Renderer
	end
	
	function self:SetTableViewItem (tableViewItem)
		self.TableViewItem = tableViewItem
	end
	
	function self:SetRenderer (renderer)
		self.Renderer = renderer
	end
	
	return CustomRenderedView
end
