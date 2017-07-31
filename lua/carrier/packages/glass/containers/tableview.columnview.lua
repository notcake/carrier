function TableView.ColumnView (UI)
	local self = {}
	local ColumnView = Class (self, UI.View)
	
	function self:ctor (column)
		self.Column = column
		
		self.Label = UI.Label ()
		self.Label:SetParent (self)
		
		self.ButtonBehaviour = Glass.ButtonBehaviour (self)
		
		self.Column.Changed:AddListener ("Glass.TableView.ColumnView." .. self:GetHashCode (), self, self.UpdateColumn)
		self:UpdateColumn ()
	end
	
	function self:dtor ()
		self.Column.Changed:RemoveListener ("Glass.TableView.ColumnView." .. self:GetHashCode ())
	end
	
	-- IView
	-- Internal
	function self:OnLayout (w, h)
		local padding = 4
		self.Label:SetRectangle (padding, 0, w - padding * 2, h)
	end
	
	function self:Render (w, h, render2d)
		if self.ButtonBehaviour:IsHovered () then
			if self.ButtonBehaviour:IsPressed () then
				render2d:FillRectangle (Color.SkyBlue, 0, 0, w, h)
			else
				render2d:FillRectangle (Color.WithAlpha (Color.SkyBlue, 64), 0, 0, w, h)
			end
		end
	end
	
	-- ColumnView
	function self:GetColumn ()
		return self.Column
	end
	
	-- Internal
	function self:UpdateColumn ()
		self.Label:SetText (self.Column:GetName ())
		self.Label:SetHorizontalAlignment (self.Column:GetAlignment ())
	end
	
	return ColumnView
end
