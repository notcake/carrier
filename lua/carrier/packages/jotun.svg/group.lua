local self = {}
Svg.Group = Class (self, Svg.Element)

function Svg.Group.FromXmlElement (xmlElement)
	local group = Svg.Group ()
	
	for node in xmlElement:GetChildEnumerator () do
		if node:GetNodeType () == Xml.NodeType.Element then
			group:AddChild (Svg.Element.FromXmlElement (node))
		end
	end
	
	return group
end

function self:ctor ()
	self.Children = {}
end

-- Element
function self:RenderContents (render2d, resolution)
	for element in self:GetChildEnumerator () do
		element:Render (render2d, resolution)
	end
end

-- Group
-- Children
function self:AddChild (child)
	self.Children [#self.Children + 1] = child
end

function self:GetChild (i)
	return self.Children [i]
end

function self:GetChildCount ()
	return #self.Children
end

function self:GetChildEnumerator ()
	return ArrayEnumerator (self.Children)
end
