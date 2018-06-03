local self = {}
Svg.Image = Class (self)

function Svg.Image.FromXml (xml)
	return Svg.Image.FromXmlDocument (Xml.Parse (xml))
end

function Svg.Image.FromXmlDocument (document)
	local image = Svg.Image ()
	
	local viewBox = document:GetAttribute ("viewBox") or "0 0 128 128"
	local x, y, w, h = string.match (document:GetAttribute ("viewBox"), "(%d*)%s*(%d*)%s*(%d*)%s*(%d*)")
	x = tonumber (x) or 0
	y = tonumber (y) or 0
	w = tonumber (w) or 128
	h = tonumber (h) or 128
	image:SetViewRectangle (x, y, w, h)
	
	for node in document:GetChildEnumerator () do
		if node:GetNodeType () == Xml.NodeType.Element then
			local type = string.lower (node:GetName ())
			if type == "path" then
				image:AddChild (Svg.Path.FromXmlElement (node))
			elseif type == "polygon" then
				image:AddChild (Svg.Polygon.FromXmlElement (node))
			elseif type == "text" then
				image:AddChild (Svg.Text.FromXmlElement (node))
			else
				assert (false, type)
			end
		end
	end
	
	return image
end

function self:ctor (viewX, viewY, viewWidth, viewHeight)
	self.ViewX      = viewX      or   0
	self.ViewY      = viewY      or   0
	self.ViewWidth  = viewWidth  or 128
	self.ViewHeight = viewHeight or 128
	
	self.Children = {}
end

-- View
function self:GetViewRectangle ()
	return self.ViewX, self.ViewY, self.ViewWidth, self.ViewHeight
end

function self:GetViewPosition ()
	return self.ViewX, self.ViewY
end

function self:GetViewX ()
	return self.ViewX
end

function self:GetViewY ()
	return self.ViewY
end

function self:GetViewSize ()
	return self.ViewWidth, self.ViewHeight
end

function self:GetViewWidth ()
	return self.ViewWidth
end

function self:GetViewHeight ()
	return self.ViewHeight
end

function self:SetViewRectangle (x, y, w, h)
	self.ViewX      = x
	self.ViewY      = y
	self.ViewWidth  = w
	self.ViewHeight = h
end

function self:SetViewPosition (x, y)
	self.ViewX = x
	self.ViewY = y
end

function self:SetViewX (x)
	self.ViewX = x
end

function self:SetViewY (y)
	self.ViewY = y
end

function self:SetViewSize (w, h)
	self.ViewWidth  = w
	self.ViewHeight = h
end

function self:SetViewWidth (w)
	self.ViewWidth = w
end

function self:SetViewHeight (h)
	self.ViewHeight = h
end

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

function self:Render (render2d, x, y)
	local x, y = x - self.ViewX, y - self.ViewY
	for element in self:GetChildEnumerator () do
		element:Render (render2d, x, y)
	end
end
