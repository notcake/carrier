local self = {}
Glass.ITableViewDataSource = Interface(self)

self.Reloaded      = Event()
self.ItemsInserted = Event()
self.ItemsRemoved  = Event()
self.ItemsMoved    = Event()

function self:ctor()
end

function self:GetItem(i, tableViewItem)
	Error("ITableViewDataSource:GetItem : Not implemented.")
end

function self:GetItemCount()
	Error("ITableViewDataSource:GetItemCount : Not implemented.")
end
