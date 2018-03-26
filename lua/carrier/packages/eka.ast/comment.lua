local self = {}
AST.Comment = Class (self, AST.Node)

function self:ctor (text)
	self.Text = text
end

-- Comment
function self:GetText ()
	return self.Text
end

function self:SetText (text)
	self.Text = text
end
