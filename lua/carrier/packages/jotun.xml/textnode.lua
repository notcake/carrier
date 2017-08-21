local self = {}
Xml.TextNode = Class (self, Node)

function self:ctor (text)
	self.Text = text
end

-- Node
function self:GetNodeType ()
	return Xml.NodeType.Text
end

function self:ToString ()
	return Xml.Escape (self.Text)
end
