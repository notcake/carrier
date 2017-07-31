ListView = {}

local OverriddenItem = {}

function Glass.ListView (UI)
	local self = {}
	local ListView = Class (self, UI.View)
	ListView.InternalDataSource = _ENV.ListView.InternalDataSource
	
	function self:ctor ()
		self.Canvas = UI.View ()
		self.Canvas:SetParent (self)
		
		self.Header = nil
		self.Footer = nil
		
		self.ItemWidth = nil
		
		self.DataSource = ListView.InternalDataSource (self.Canvas)
		
		-- Layout
		self.ResolvedItemWidth = nil
		self.ViewWidth  = nil
		self.ViewHeight = nil
		
		self.VisibleItems     = {}
		self.VisibleItemTypes = {}
		
		-- Visible range is startIndex, length
		-- Visible range is also y, dy
		-- TODO: How does this play with insets?
		
		-- Insets
		-- Scroll viewport is height minus insets
		-- Scroll content size is normal
		
		-- There is no god
		-- Views cannot be added in layout code.
		self.VerticalScrollbar = UI.VerticalScrollbar ()
		self.VerticalScrollbar:SetParent (self)
		self.VerticalScrollbar:SetVisible (false)
		self.HorizontalScrollbar = UI.HorizontalScrollbar ()
		self.HorizontalScrollbar:SetParent (self)
		self.HorizontalScrollbar:SetVisible (false)
		self.ScrollbarCorner = UI.ScrollbarCorner ()
		self.ScrollbarCorner:SetParent (self)
		self.ScrollbarCorner:SetVisible (false)
		
		self.DataSource.Reloaded     :AddListener ("Glass.ListView." .. self:GetHashCode (), self, self.Reload)
		self.DataSource.ItemsInserted:AddListener ("Glass.ListView." .. self:GetHashCode (), self, self.Reload)
		self.DataSource.ItemsRemoved :AddListener ("Glass.ListView." .. self:GetHashCode (), self, self.Reload)
		self.DataSource.ItemsMoved   :AddListener ("Glass.ListView." .. self:GetHashCode (), self, self.Reload)
	end
	
	function self:dtor ()
		self.DataSource:dtor ()
	end
	
	-- IView
	-- Internal
	function self:OnLayout (w, h)
		self.Canvas:SetRectangle (0, 0, w, h)
		
		self:RecomputeLayout ()
		self:LayoutVisibleItems ()
		-- Invalidate item heights on width change
		
		-- Invalidate visible range on height change
		-- Invalidate scroll position on height change
	end
	
	-- ListView
	function self:GetHeader ()
		return self.Header
	end
	
	function self:GetFooter ()
		return self.Footer
	end
	
	function self:SetHeader (header)
		if self.Header == header then return end
		
		self.Header = header
		
		if self.Header then
			self.Header:SetParent (self)
		end
		
		self:InvalidateLayout ()
	end
	
	function self:SetFooter (footer)
		if self.Footer == footer then return end
		
		self.Footer = footer
		
		if self.Footer then
			self.Footer:SetParent (self)
		end
		
		self:InvalidateLayout ()
	end
	
	function self:GetItemWidth ()
		return self.ItemWidth
	end
	
	function self:SetItemWidth (width)
		if width < 0 then width = nil end
		
		if self.ItemWidth == width then return end
		
		self.ItemWidth = width
		
		self:InvalidateLayout ()
	end
	
	-- Items
	function self:AddItem (listViewItem)
		self.DataSource:AddItem (listViewItem)
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
	
	function self:InsertItem (index, listViewItem)
		self.DataSource:InsertItem (index, listViewItem)
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
	function self:RecomputeLayout ()
		local w, h = self:GetSize ()
		
		local verticalScrollbarNeeded   = false
		local verticalScrollbarWidth    = 0
		local horizontalScrollbarNeeded = false
		local horizontalScrollbarHeight = 0
		
		local headerHeight = 0
		local footerHeight = 0
		
		local viewWidth  = w
		local viewHeight = h
		local itemWidth = self.ItemWidth or viewWidth
		if self.Header then
			headerHeight = select (2, self.Header:GetPreferredSize (itemWidth, nil))
			viewHeight = viewHeight - headerHeight
		end
		if self.Footer then
			footerHeight = select (2, self.Footer:GetPreferredSize (itemWidth, nil))
			viewHeight = viewHeight - footerHeight
		end
		
		local contentHeight = self.DataSource:GetTotalHeight (itemWidth)
		
		-- Determine vertical scrollbar presence
		if contentHeight > viewHeight then
			verticalScrollbarNeeded = true
			verticalScrollbarWidth  = self.VerticalScrollbar:GetPreferredSize (w, h)
			
			-- Recompute viewWidth and itemWidth
			viewWidth = viewWidth - verticalScrollbarWidth
			itemWidth = self.ItemWidth or viewWidth
			
			-- NOTE: viewHeight and contentHeight are now invalid if itemWidth is
			--       tied to viewWidth, but this is fine since it's only used to re-determine
			--       vertical scrollbar presence and they are recomputed after that.
		end
		
		-- Determine horizontal scrollbar presence
		-- Horizontal scrollbar will affect viewHeight
		if itemWidth > viewWidth then
			horizontalScrollbarNeeded = true
			horizontalScrollbarHeight = select (2, self.HorizontalScrollbar:GetPreferredSize (w, h))
			
			-- Recompute viewHeight for second vertical scrollbar determination
			viewHeight = viewHeight - horizontalScrollbarHeight
		end
		
		-- Determine vertical scrollbar presence with updated viewHeight
		if not verticalScrollbarNeeded and
		   contentHeight > viewHeight then
			verticalScrollbarNeeded = true
			verticalScrollbarWidth  = self.VerticalScrollbar:GetPreferredSize (w, h)
			
			-- Recompute viewWidth and itemWidth
			viewWidth = viewWidth - verticalScrollbarWidth
			itemWidth = self.ItemWidth or viewWidth
		end
		
		-- Recompute viewHeight and contentHeight if itemWidth is tied to viewWidth
		if verticalScrollbarNeeded and not self.ItemWidth then
			viewHeight = h
			if self.Header then
				headerHeight = select (2, self.Header:GetPreferredSize (itemWidth, nil))
				viewHeight = viewHeight - headerHeight
			end
			if self.Footer then
				footerHeight = select (2, self.Footer:GetPreferredSize (itemWidth, nil))
				viewHeight = viewHeight - footerHeight
			end
			-- NOTE: There's never a horizontal scrollbar if itemWidth is tied to viewWidth
			--       anyway, but subtract it off for correctness' sake.
			viewHeight = viewHeight - (horizontalScrollbarNeeded and horizontalScrollbarHeight or 0)
			
			-- Recompute contentHeight
			contentHeight = self.DataSource:GetTotalHeight (itemWidth)
		end
		
		-- Layout header
		if self.Header then
			self.Header:SetRectangle (0, 0, math.max (itemWidth, viewWidth), headerHeight)
		end
		
		-- Layout footer
		if self.Footer then
			local bottom = h - (horizontalScrollbarNeeded and horizontalScrollbarHeight or 0)
			self.Footer:SetRectangle (0, bottom - footerHeight, math.max (itemWidth, viewWidth), footerHeight)
		end
		
		-- Layout vertical scrollbar
		self.VerticalScrollbar:SetVisible (verticalScrollbarNeeded)
		if verticalScrollbarNeeded then
			self.VerticalScrollbar:SetRectangle (w - verticalScrollbarWidth, 0, verticalScrollbarWidth, viewHeight)
			self.VerticalScrollbar:SetContentSize (contentHeight)
			self.VerticalScrollbar:SetViewSize (viewHeight)
		end
		
		-- Layout horizontal scrollbar
		self.HorizontalScrollbar:SetVisible (horizontalScrollbarNeeded)
		if horizontalScrollbarNeeded then
			self.HorizontalScrollbar:SetRectangle (0, h - horizontalScrollbarHeight, viewWidth, horizontalScrollbarHeight)
			self.HorizontalScrollbar:SetContentSize (itemWidth)
			self.HorizontalScrollbar:SetViewSize (viewWidth)
		end
		
		-- Layout scrollbar corner
		self.ScrollbarCorner:SetVisible (verticalScrollbarNeeded and horizontalScrollbarNeeded)
		if verticalScrollbarNeeded and horizontalScrollbarNeeded then
			self.ScrollbarCorner:SetRectangle (self.VerticalScrollbar:GetX (), self.HorizontalScrollbar:GetY (), self.VerticalScrollbar:GetWidth (), self.HorizontalScrollbar:GetHeight ())
		end
		
		self.ViewWidth  = viewWidth
		self.ViewHeight = viewHeight
		self.ResolvedItemWidth = itemWidth
	end
	
	function self:LayoutVisibleItems ()
		local y = 0
		if self.Header then y = y + self.Header:GetHeight () end
		for i = 1, #self.VisibleItems do
			local listViewItem = self.VisibleItems [i]
			local h = self.DataSource:GetItemHeight (i, self.ResolvedItemWidth)
			listViewItem:SetRectangle (0, y, self.ResolvedItemWidth, h)
			y = y + h
		end
	end
	
	function self:CreatePool (itemType)
		return Pool (
			function ()
				local listViewItem = self.DataSource:CreateItem (itemType)
				if listViewItem then
					listViewItem:SetParent (self.Canvas)
				end
				return listViewItem
			end,
			function (listViewItem)
				listViewItem:SetVisible (true)
			end,
			function (listViewItem)
				listViewItem:SetVisible (false)
			end,
			function (listViewItem)
				self.DataSource:DestroyItem (itemType, listViewItem)
			end
		)
	end
	
	function self:GetPool (itemType)
		self.DefaultPool = self.DefaultPool or self:CreatePool (nil)
		
		if itemType == nil then
			return self.DefaultPool
		else
			self.Pools = self.Pools or {}
			self.Pools [itemType] = self.Pools [itemType] or self:CreatePool (itemType)
			
			return self.Pools [itemType]
		end
	end
	
	function self:Reload ()
		for i = #self.VisibleItems, 1, -1 do
			local listViewItem = self.VisibleItems [i]
			self.DataSource:UnbindItem (i, listViewItem)
			local itemType = self.VisibleItemTypes [i]
			if itemType == OverriddenItem then
				listViewItem:SetVisible (false)
			else
				local pool = self:GetPool (itemType)
				pool:Free (listViewItem)
			end
			
			self.VisibleItems [i] = nil
			self.VisibleItemTypes [i] = nil
		end
		
		for i = 1, self.DataSource:GetItemCount () do
			local itemType = self.DataSource:GetItemType (i)
			local pool = self:GetPool (itemType)
			local listViewItem = pool:Alloc ()
			local boundItem = self.DataSource:BindItem (i, listViewItem)
			if boundItem ~= listViewItem then
				itemType = OverriddenItem
				boundItem:SetParent (self.Canvas)
				pool:Free (listViewItem)
			end
			
			self.VisibleItems [#self.VisibleItems + 1] = boundItem
			self.VisibleItemTypes [#self.VisibleItemTypes + 1] = itemType
		end
		
		self:LayoutVisibleItems ()
	end
	
	return ListView
end
