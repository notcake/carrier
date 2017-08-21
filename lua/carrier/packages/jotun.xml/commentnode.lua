local self = {}
Xml.CommentNode = Class (self, Xml.Node)

function self:ctor (text)
	self.Text = text
end

-- Node
function self:GetNodeType ()
	return Xml.NodeType.Comment
end

function self:ToString ()
	return "<!-- " .. self.Text .. " -->"
end
