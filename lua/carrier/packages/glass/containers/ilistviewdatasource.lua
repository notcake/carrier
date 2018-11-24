local self = {}
Glass.IListViewDataSource = Interface(self)

self.Reloaded      = Event()
self.ItemsInserted = Event()
self.ItemsRemoved  = Event()
self.ItemsMoved    = Event()

--[[
	ListViewItem lifecycle
	- Created
	- Bound
	- Unbound
	- Destroyed
	
	Use cases
	- Unique items, manual creation
		- return nil for GetItemType
		- return nil for CreateItem
		- BindItem creates the item
		- UnbindItem destroys the item
	- Homogenous list
		- return nil for GetItemType
		- return ListViewItem for CreateItem
	- Heterogenous list
		- return something for GetItemType
		- return ListViewItem for CreateItem
]]

function self:ctor()
end

function self:GetItemCount()
	Error("IListViewDataSource:GetItemCount : Not implemented.")
end

function self:GetItemType(i)
	return nil
end

function self:CreateItem(type)
	Error("IListViewDataSource:CreateItem : Not implemented.")
end

function self:DestroyItem(type, listViewItem)
	listViewItem:dtor()
end

function self:BindItem(i, listViewItem)
	Error("IListViewDataSource:BindItem : Not implemented.")
end

function self:UnbindItem(i, listViewItem)
end

function self:GetTotalHeight(width)
	return self:GetRangeHeight(1, self:GetItemCount(), width)
end

function self:GetRangeHeight(startIndex, count, width)
	Error("IListViewDataSource:GetRangeHeight : Not implemented.")
end

function self:GetItemHeight(i, width)
	Error("IListViewDataSource:GetItemHeight : Not implemented.")
end
