local self = {}
AST.Comment = Class(self, AST.Statement)

function self:ctor(text)
	self.Text = text
end

-- Node
function self:ToString()
	return "// " .. self.Text
end

-- Comment
function self:GetText()
	return self.Text
end

function self:SetText(text)
	self.Text = text
end
