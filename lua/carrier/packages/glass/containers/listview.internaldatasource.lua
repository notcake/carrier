local self = {}
ListView.InternalDataSource = Class (self, Glass.IListViewDataSource)

self.Reloaded      = Event ()
self.ItemsInserted = Event ()
self.ItemsRemoved  = Event ()
self.ItemsMoved    = Event ()

function self:ctor (canvas)
	self.Canvas = canvas
	
	self.DataSource = nil
	
	self.ItemCount = 0
	self.Items     = {}
end

function self:dtor ()
	self:SetDataSource (nil)
end

-- IListViewDataSource
function self:GetItemCount ()
	return self.ItemCount
end

function self:GetItemType (i)
	if not self.DataSource then return nil end
	
	return self.DataSource:GetItemType (i)
end

function self:CreateItem (type)
	if not self.DataSource then return end
	
	return self.DataSource:CreateItem (type)
end

function self:DestroyItem (type, listViewItem)
	if not self.DataSource then return end
	
	return self.DataSource:DestroyItem (type)
end

function self:BindItem (i, listViewItem)
	if not self.DataSource then return end
	
	return self.DataSource:BindItem (i, listViewItem)
end

function self:UnbindItem (i, listViewItem)
	if not self.DataSource then return end
	
	return self.DataSource:UnbindItem (i, listViewItem)
end

function self:GetTotalHeight (width)
	if not self.DataSource then return 0 end
	
	return self.DataSource:GetTotalHeight (width)
end

function self:GetRangeHeight (startIndex, count, width)
	if not self.DataSource then return 0 end
	
	return self.DataSource:GetRangeHeight (startIndex, count, width)
end

function self:GetItemHeight (i, width)
	if not self.DataSource then return 0 end
	
	return self.DataSource:GetItemHeight (i, width)
end

-- ListViewInternalDataSource
function self:AddItem (listViewItem)
	self.ItemCount = self.ItemCount + 1
	self.Items [self.ItemCount] = listViewItem
	
	self.ItemsInserted:Dispatch (self.ItemCount, 1)
end

function self:GetDataSource ()
	return self.DataSource
end

function self:SetDataSource (dataSource)
	if self.DataSource == dataSource then return end
	
	if self.DataSource then
		self:UnbindDataSource (self.DataSource)
	end
	
	self.DataSource = dataSource
	
	if self.DataSource then
		self:BindDataSource (self.DataSource)
	end
end

-- Internal
function self:BindDataSource (dataSource)
	self.DataSource.Reloaded:AddListener ("Glass.ListView.InternalDataSource." .. self:GetHashCode (),
		function ()
			self.ItemCount = self.DataSource:GetItemCount ()
			
			self.Reloaded:Dispatch ()
			
			-- Visible range invalidated?
		end
	)
	
	self.DataSource.ItemsInserted:AddListener ("Glass.ListView.InternalDataSource." .. self:GetHashCode (),
		function (startIndex, count)
			self.ItemCount = self.ItemCount + count
			
			self.ItemsInserted:Dispatch (startIndex, count)
			
			-- Outside visible range -> no op, update some accounting
			-- Inside visible range  -> eek
		end
	)
	
	self.DataSource.ItemsRemoved:AddListener ("Glass.ListView.InternalDataSource." .. self:GetHashCode (),
		function (startIndex, count)
			self.ItemCount = self.ItemCount - count
			
			self.ItemsRemoved:Dispatch (startIndex, count)
			
			-- Outside visible range -> no op, update some accounting
			-- Inside visible range  -> eek
		end
	)
	
	self.DataSource.ItemsMoved:AddListener ("Glass.ListView.InternalDataSource." .. self:GetHashCode (),
		function (sourceIndex, destinationIndex, count)
			self.ItemsMoved:Dispatch (sourceIndex, destinationIndex, count)
			
			-- Outside visible range -> no op, update some accounting
			-- Inside visible range  -> eek
		end
	)
end

function self:UnbindDataSource (dataSource)
	self.DataSource.Reloaded     :RemoveListener ("Glass.ListView.InternalDataSource." .. self:GetHashCode ())
	self.DataSource.ItemsInserted:RemoveListener ("Glass.ListView.InternalDataSource." .. self:GetHashCode ())
	self.DataSource.ItemsRemoved :RemoveListener ("Glass.ListView.InternalDataSource." .. self:GetHashCode ())
	self.DataSource.ItemsMoved   :RemoveListener ("Glass.ListView.InternalDataSource." .. self:GetHashCode ())
end
