local self = {}
Svg.Image = Class (self)

function Svg.Image.FromXml (xml)
	return Svg.Image.FromXmlDocument (Xml.Parse (xml))
end

function Svg.Image.FromXmlDocument (xmlDocument)
	local image = Svg.Image ()
	
	local viewBox = xmlDocument:GetAttribute ("viewBox") or "0 0 128 128"
	local parser = PathParser (viewBox)
	x = parser:AcceptNumber () or 0
	parser:AcceptCommaWhitespace ()
	y = parser:AcceptNumber () or 0
	parser:AcceptCommaWhitespace ()
	w = parser:AcceptNumber () or 128
	parser:AcceptCommaWhitespace ()
	h = parser:AcceptNumber () or 128
	parser:AcceptCommaWhitespace ()
	image:SetViewRectangle (x, y, w, h)
	
	for node in xmlDocument:GetChildEnumerator () do
		if node:GetNodeType () == Xml.NodeType.Element then
			image:AddChild (Svg.Element.FromXmlElement (node))
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

local matrix3x3d = Cat.Matrix3x3d.Identity ()
function self:Render (render2d, x, y)
	local x, y = x - self.ViewX, y - self.ViewY
	
	if x == 0 and y == 0 then
		self:RenderContents (render2d, 1)
	else
		matrix3x3d [2], matrix3x3d [5] = x, y
		render2d:WithMatrixMultiplyRight (matrix3x3d,
			function ()
				self:RenderContents (render2d, 1)
			end
		)
	end
end

-- Internal
function self:RenderContents (render2d, resolution)
	for element in self:GetChildEnumerator () do
		element:Render (render2d, resolution)
	end
end
