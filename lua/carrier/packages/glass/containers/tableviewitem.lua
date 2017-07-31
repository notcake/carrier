local self = {}
Glass.TableViewItem = Class (self)

function self:ctor (text)
	self.ColumnTypes      = {}
	self.Columns          = {}
	self.ColumnAlignments = {}
	
	if text then
		self:SetText (text)
	end
end

function self:GetText ()
	return self:GetColumnText (1)
end

function self:GetColumnText (column)
	if self.ColumnTypes [column] == Glass.TableViewColumnType.Text then
		return self.Columns [column]
	else
		return nil
	end
end

function self:GetColumnAlignment (column)
	return self.ColumnAlignments [column] or Glass.HorizontalAlignment.Left
end

function self:SetText (text)
	self:SetColumnText (1, text)
end

function self:SetColumnText (column, text)
	self.ColumnTypes [column] = Glass.TableViewColumnType.Text
	self.Columns [column] = text
end

function self:SetColumnAlignment (column, alignment)
	self.ColumnAlignments [column] = alignment
end
