local OverriddenItem = {}

local self = {}
Glass.ListView = Class (self, Glass.View)

function self:ctor ()
	self.Canvas = Glass.View ()
	self.Canvas:SetParent (self)
	
	self.Header = nil
	self.Footer = nil
	
	self.ItemWidth = nil
	
	self.DataSource = Glass.ListView.InternalDataSource (self.Canvas)
	
	-- Layout
	self.ZOrderValid = false
	
	self.HeaderHeight = 0
	self.FooterHeight = 0
	self.ViewWidth       = nil
	self.ViewHeight      = nil
	self.OuterViewHeight = nil
	self.ContentHeight     = nil
	self.ResolvedItemWidth = nil
	
	self.VisibleItems     = {}
	self.VisibleItemTypes = {}
	
	self.ViewLayoutWidth  = nil
	self.ViewLayoutHeight = nil
	self.ViewLayoutValid  = false
	self.ItemLayoutValid  = false
	
	self.HeaderFooterLayoutValid = false
	
	self.HorizontalScrollPosition = 0
	self.VerticalScrollPosition   = 0
	
	-- Visible range is startIndex, length
	-- Visible range is also y, dy
	-- TODO: How does this play with insets?
	
	self.VerticalScrollbar = Glass.VerticalScrollbar ()
	self.VerticalScrollbar:SetParent (self)
	self.VerticalScrollbar:SetVisible (false)
	self.VerticalScrollbar.ScrollAnimated:AddListener (
		function (scrollPosition)
			self.VerticalScrollPosition = scrollPosition
			
			self:LayoutVisibleItems ()
		end
	)
	self.HorizontalScrollbar = Glass.HorizontalScrollbar ()
	self.HorizontalScrollbar:SetParent (self)
	self.HorizontalScrollbar:SetVisible (false)
	self.HorizontalScrollbar.ScrollAnimated:AddListener (
		function (scrollPosition)
			self.HorizontalScrollPosition = scrollPosition
			
			self:LayoutHeaderFooter ()
			self:LayoutVisibleItems ()
		end
	)
	self.ScrollbarCorner = Glass.ScrollbarCorner ()
	self.ScrollbarCorner:SetParent (self)
	self.ScrollbarCorner:SetVisible (false)
	
	self.DataSource.Reloaded     :AddListener ("Glass.ListView." .. self:GetHashCode (), self, self.OnReloaded)
	self.DataSource.ItemsInserted:AddListener ("Glass.ListView." .. self:GetHashCode (), self, self.OnItemsInserted)
	self.DataSource.ItemsRemoved :AddListener ("Glass.ListView." .. self:GetHashCode (), self, self.OnItemsRemoved)
	self.DataSource.ItemsMoved   :AddListener ("Glass.ListView." .. self:GetHashCode (), self, self.OnReloaded)
end

function self:dtor ()
	self.DataSource:dtor ()
end

-- IView
-- Internal
function self:OnLayout (w, h)
	local Profiler = require ("dt.Profiler").Profiler
	Profiler:BeginSection ("Glass.ListView.OnLayout")
	
	if not self.ZOrderValid then
		self:LayoutZOrder ()
	end
	
	if self.ViewLayoutWidth  ~= w or
	   self.ViewLayoutHeight ~= h then
		self.ViewLayoutValid = false
	end
	
	if not self.ViewLayoutValid then
		self:LayoutView ()
	end
	
	if not self.ItemLayoutValid then
		self:LayoutVisibleItems ()
	end
	
	if not self.HeaderFooterLayoutValid then
		self:LayoutHeaderFooter ()
	end
	
	-- Invalidate item heights on width change
	
	-- Invalidate visible range on height change
	-- Invalidate scroll position on height change
	
	Profiler:EndSection ()
end

function self:OnMouseWheel (delta)
	local scrollbar = nil
	if self:GetEnvironment ():GetKeyboard ():IsShiftDown () and self.HorizontalScrollbar:IsVisible () then
		scrollbar = self.HorizontalScrollbar
	elseif self.VerticalScrollbar:IsVisible () then
		scrollbar = self.VerticalScrollbar
	end
	
	if not scrollbar then return end
	
	scrollbar:ScrollSmallIncrement (-delta, true)
	return true
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
	
	self:InvalidateZOrder ()
	self:InvalidateViewLayout ()
	self:InvalidateHeaderFooterLayout ()
end

function self:SetFooter (footer)
	if self.Footer == footer then return end
	
	self.Footer = footer
	
	if self.Footer then
		self.Footer:SetParent (self)
	end
	
	self:InvalidateZOrder ()
	self:InvalidateViewLayout ()
	self:InvalidateHeaderFooterLayout ()
end

function self:GetItemWidth ()
	return self.ItemWidth
end

function self:SetItemWidth (width)
	if width < 0 then width = nil end
	
	if self.ItemWidth == width then return end
	
	self.ItemWidth = width
	
	self:InvalidateViewLayout ()
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
function self:LayoutZOrder ()
	self.ZOrderValid = true
	
	if self.Header then self.Header:BringToFront () end
	if self.Footer then self.Footer:BringToFront () end
	
	self.VerticalScrollbar  :BringToFront ()
	self.HorizontalScrollbar:BringToFront ()
	self.ScrollbarCorner    :BringToFront ()
end

function self:LayoutView ()
	local w, h = self:GetSize ()
	
	self.ViewLayoutValid  = true
	self.ViewLayoutWidth  = w
	self.ViewLayoutHeight = h
	
	local verticalScrollbarNeeded   = false
	local verticalScrollbarWidth    = 0
	local horizontalScrollbarNeeded = false
	local horizontalScrollbarHeight = 0
	
	local headerHeight = 0
	local footerHeight = 0
	
	local viewWidth  = w
	local viewHeight = h
	local outerViewHeight = h
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
		viewHeight      = viewHeight      - horizontalScrollbarHeight
		outerViewHeight = outerViewHeight - horizontalScrollbarHeight
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
	
	-- Update header height
	if self.HeaderHeight ~= headerHeight then
		self.HeaderHeight = headerHeight
		self.HeaderFooterLayoutValid = false
	end
	
	-- Update footer height
	if self.FooterHeight ~= footerHeight then
		self.FooterHeight = footerHeight
		self.HeaderFooterLayoutValid = false
	end
	
	-- Update item width
	if self.ResolvedItemWidth ~= itemWidth or
	   self.ViewWidth ~= viewWidth then
		self.ResolvedItemWidth = itemWidth
		self.ItemLayoutValid = false
		self.HeaderFooterLayoutValid = false
	end
	
	if self.ContentHeight ~= contentHeight then
		self.ContentHeight = contentHeight
		self.ItemLayoutValid = false
	end
	
	-- Update view size
	self.ViewWidth       = viewWidth
	self.ViewHeight      = viewHeight
	self.OuterViewHeight = outerViewHeight
	
	-- Scrollbar content sizes and view sizes have to be updated even if invisible
	-- so that we animate back to the top left properly
	-- Layout vertical scrollbar
	self.VerticalScrollbar:SetVisible (verticalScrollbarNeeded)
	self.VerticalScrollbar:SetRectangle (self.ViewWidth, 0, verticalScrollbarWidth, self.OuterViewHeight)
	self.VerticalScrollbar:SetContentSize (self.ContentHeight)
	self.VerticalScrollbar:SetViewSize (self.ViewHeight)
	
	-- Layout horizontal scrollbar
	self.HorizontalScrollbar:SetVisible (horizontalScrollbarNeeded)
	self.HorizontalScrollbar:SetRectangle (0, self.OuterViewHeight, self.ViewWidth, horizontalScrollbarHeight)
	self.HorizontalScrollbar:SetContentSize (self.ResolvedItemWidth)
	self.HorizontalScrollbar:SetViewSize (self.ViewWidth)
	
	-- Layout scrollbar corner
	self.ScrollbarCorner:SetVisible (verticalScrollbarNeeded and horizontalScrollbarNeeded)
	if verticalScrollbarNeeded and horizontalScrollbarNeeded then
		self.ScrollbarCorner:SetRectangle (self.VerticalScrollbar:GetX (), self.HorizontalScrollbar:GetY (), self.VerticalScrollbar:GetWidth (), self.HorizontalScrollbar:GetHeight ())
	end
end

function self:LayoutVisibleItems ()
	self.ItemLayoutValid = true
	
	self.Canvas:SetRectangle (
		-self.HorizontalScrollPosition,
		-self.VerticalScrollPosition,
		math.max (self.ResolvedItemWidth, self.ViewWidth),
		math.max (self.ContentHeight + self.HeaderHeight + self.FooterHeight, self.OuterViewHeight)
	)
	
	local y = 0
	if self.Header then y = y + self.Header:GetHeight () end
	for i = 1, #self.VisibleItems do
		local listViewItem = self.VisibleItems [i]
		local h = self.DataSource:GetItemHeight (i, self.ResolvedItemWidth)
		listViewItem:SetRectangle (0, y, self.ResolvedItemWidth, h)
		y = y + h
	end
end

-- Sizes depend on item width, view width and computed header and footer height
-- Footer position depends on view size
function self:LayoutHeaderFooter ()
	self.HeaderFooterLayoutValid = true
	
	local headerFooterWidth = math.max (self.ResolvedItemWidth, self.ViewWidth)
	
	-- Layout header
	if self.Header then
		self.Header:SetRectangle (-self.HorizontalScrollPosition, 0, headerFooterWidth, self.HeaderHeight)
	end
	
	-- Layout footer
	if self.Footer then
		self.Footer:SetRectangle (-self.HorizontalScrollPosition, self.OuterViewHeight - self.FooterHeight, headerFooterWidth, self.FooterHeight)
	end
end

function self:InvalidateZOrder ()
	self.ZOrderValid = false
	
	self:InvalidateLayout ()
end

function self:InvalidateViewLayout ()
	self.ViewLayoutValid = false
	
	self:InvalidateLayout ()
end

function self:InvalidateContentHeight ()
	self:InvalidateViewLayout ()
end

function self:InvalidateItemLayout ()
	self.ItemLayoutValid = false
	
	self:InvalidateLayout ()
end

function self:InvalidateHeaderFooterLayout ()
	self.HeaderFooterLayoutValid = false
	
	self:InvalidateLayout ()
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

-- Data source events
function self:OnReloaded ()
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
		
		self.VisibleItems [i] = boundItem
		self.VisibleItemTypes [i] = itemType
	end
	
	self:InvalidateContentHeight ()
	self:InvalidateItemLayout ()
end

function self:OnItemsInserted (startIndex, count)
	-- Shift everything up
	for i = #self.VisibleItems, startIndex, -1 do
		self.VisibleItems [i + count] = self.VisibleItems [i]
		self.VisibleItemTypes [i + count] = self.VisibleItemTypes [i]
	end
	
	-- Create new items
	for i = startIndex, startIndex + count - 1 do
		local itemType = self.DataSource:GetItemType (i)
		local pool = self:GetPool (itemType)
		local listViewItem = pool:Alloc ()
		local boundItem = self.DataSource:BindItem (i, listViewItem)
		if boundItem ~= listViewItem then
			itemType = OverriddenItem
			boundItem:SetParent (self.Canvas)
			pool:Free (listViewItem)
		end
		
		self.VisibleItems [i] = boundItem
		self.VisibleItemTypes [i] = itemType
	end
	
	self:InvalidateContentHeight ()
	self:InvalidateItemLayout ()
end

function self:OnItemsRemoved (startIndex, count)
	-- Delete removed items
	for i = startIndex, startIndex + count - 1 do
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
	
	-- Shift everything down
	local itemCount = #self.VisibleItems
	for i = startIndex, startIndex + count - 1 do
		self.VisibleItems [i] = self.VisibleItems [i + count]
		self.VisibleItemTypes [i] = self.VisibleItemTypes [i + count]
	end
	
	self:InvalidateContentHeight ()
	self:InvalidateItemLayout ()
end
