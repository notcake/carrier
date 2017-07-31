ListView = {}

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
	end
	
	function self:dtor ()
		self.DataSource:dtor ()
	end
	
	-- IView
	-- Internal
	function self:OnLayout (w, h)
		self.Canvas:SetRectangle (0, 0, w, h)
		
		self:RecomputeLayout ()
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
	end
	
	return ListView
end
