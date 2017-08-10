local self = {}
Glass.TableView.ColumnView = Class (self, Glass.View)

function self:ctor (column)
	self.Column = column
	
	self.Label = Glass.Label ()
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
	if self.ButtonBehaviour:IsPressed () then
		render2d:FillRectangle (Color.LightBlue, 0, 0, w, h)
	elseif self.ButtonBehaviour:IsHovered () then
		render2d:FillRectangle (Color.WithAlpha (Color.LightBlue, 192), 0, 0, w, h)
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
