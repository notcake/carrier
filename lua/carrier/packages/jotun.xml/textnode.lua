local self = {}
Xml.TextNode = Class (self, Node)

function self:ctor (text)
	self.Text = text
end

function self:__tostring ()
	return self.Text
end
