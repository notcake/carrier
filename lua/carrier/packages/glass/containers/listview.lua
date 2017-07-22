function Glass.ListView (UI)
	local self = {}
	local ListView = Class (self, UI.View)
	
	function self:ctor ()
		self.Canvas = UI.View ()
		self.Canvas:SetParent (self)
	end
	
	-- IView
	-- Internal
	function self:OnLayout (w, h)
		self.Canvas:SetRectangle (0, 0, w, h)
	end
	
	-- ListView
	function self:AddItem (x)
		self:InsertItem (self:GetItemCount () + 1, x)
	end
	
	function self:GetItemCount ()
		
	end
	
	return ListView
end
