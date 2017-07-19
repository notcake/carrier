local Async = require_provider ("Pylon.Async")

local self = {}
Desktop = Class (self)

function self:ctor ()
	self.Items = {}
	
	self.Invalidating = false
end

function self:dtor ()
	self:ClearItems ()
	self:RecreateContextMenu ()
	
	hook.Remove ("ContextMenuClose", "Glass.GarrysMod.Desktop")
end

function self:AddItem (text, icon)
	local item = DesktopItem (self, text, icon)
	
	self.Items [item] = true
	list.Set ("DesktopWindows", item:GetId (),
		{
			title     = item:GetText (),
			icon      = item:GetIcon (),
			width     = 1,
			height    = 1,
			onewindow = false,
			init      = function (_, window)
				window:GetParent ():Close ()
				window:Remove ()
				item.Click:Dispatch ()
			end
		}
	)
	
	self:InvalidateItems ()
	
	return item
end

function self:ClearItems ()
	for item in pairs (self.Items) do
		self:RemoveItem (item)
	end
end

function self:RemoveItem (item)
	if not self.Items [item] then return end
	
	self.Items [item] = nil
	list.Set ("DesktopWindows", item:GetId (), nil)
	
	self:InvalidateItems ()
end

-- Internal
function self:InvalidateItems ()
	if self.Invalidating then return end
	
	self.Invalidating = true
	
	-- Wait for the next frame
	Async.WaitTick ():wait (
		function ()
			-- Abort if RecreateContextMenu has been invoked explicitly
			if not self.Invalidating then return end
			
			if not g_ContextMenu or
			   not g_ContextMenu:IsValid () then
				return
			end
			
			-- Wait until the context menu closes
			if g_ContextMenu:IsVisible () then
				hook.Add ("ContextMenuClose", "Glass.GarrysMod.Desktop",
					function ()
						hook.Remove ("ContextMenuClose", "Glass.GarrysMod.Desktop")
						
						if not self.Invalidating then return end
						
						self:RecreateContextMenu ()
					end
				)
			else
				self:RecreateContextMenu ()
			end
		end
	)
end

function self:RecreateContextMenu ()
	if not self.Invalidating then return end
	
	self.Invalidating = false
	if g_ContextMenu and g_ContextMenu:IsValid () then
		g_ContextMenu:Remove ()
		CreateContextMenu ()
	end
end
