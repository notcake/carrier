local self = {}
Glass.TableView.ColumnResizeGrip = Class(self, Glass.View)

function self:ctor(column)
	self.Column = column
	
	self:SetCursor(Glass.Cursor.SizeEastWest)
	
	self.DragWidth = nil
	
	self.DragBehaviour = Glass.DragBehaviour(self)
	self.DragBehaviour.Started:AddListener(
		function()
			self.DragWidth = self.Column:GetWidth()
		end
	)
	self.DragBehaviour.Updated:AddListener(
		function(dx, dy)
			self.Column:SetWidth(math.max(self.Column:GetMinimumWidth(), self.DragWidth + dx))
		end
	)
end

-- ColumnResizeGrip
function self:GetColumn()
	return self.Column
end
