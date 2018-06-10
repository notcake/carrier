local self = {}
Svg.Element = Class (self)

function Svg.Element.FromXmlElement (xmlElement)
	local element = nil
	
	local type = string.lower (xmlElement:GetName ())
	if type == "path" then
		element = Svg.Path.FromXmlElement (xmlElement)
	elseif type == "polygon" then
		element = Svg.Polygon.FromXmlElement (xmlElement)
	elseif type == "text" then
		element = Svg.Text.FromXmlElement (xmlElement)
	elseif type == "g" then
		element = Svg.Group.FromXmlElement (xmlElement)
	else
		assert (false, type)
	end
	
	if xmlElement:GetAttribute ("transform") then
		local transforms = {}
		for name, arguments in string.gmatch (xmlElement:GetAttribute ("transform"), "([a-zA-Z0-9_]+)%s*%(([^%)]*)%)") do
			local parser = PathParser (arguments)
			
			local arguments = {}
			parser:AcceptWhitespace ()
			while not parser:IsEndOfInput () do
				local value = parser:AcceptNumber ()
				if not value then break end
				
				arguments [#arguments + 1] = tonumber (value)
				parser:AcceptCommaWhitespace ()
			end
			
			if name == "scale" then
				local x, y = arguments [1], arguments [2] or arguments [1]
				transforms [#transforms + 1] = Cat.Matrix3x3d (
					x, 0, 0,
					0, y, 0,
					0, 0, 1
				)
			else
				assert (false, name)
			end
		end
		
		if #transforms > 0 then
			local transform = transforms [1]
			local matrix3x3d = Cat.Matrix3x3d ()
			for i = 2, #transforms do
				Cat.Matrix3x3d.MatrixMultiply (transform, transforms [i], matrix3x3d)
				transform, matrix3x3d = matrix3x3d, transform
			end
			
			element:SetTransform (transform)
		end
	end
	
	return element
end

function self:ctor ()
	self.Transform = nil
	self.TransformL2Norm = 1
end

-- Element
function self:GetTransform (out)
	return self.Transform and self.Transform:Clone (out) or Cat.Matrix3x3d.Identity (out)
end

local matrix2x2d = Cat.Matrix2x2d ()
function self:SetTransform (matrix3x3d)
	if matrix3x3d then
		self.Transform = Cat.Matrix3x3d.Clone (matrix3x3d, self.Transform)
		Cat.Matrix3x3d.ToMatrix2x2d (self.Transform, matrix2x2d)
		self.TransformL2Norm = matrix2x2d:L2Norm ()
	else
		self.Transform = nil
		self.TransformL2Norm = 1
	end
end

function self:Render (render2d, resolution)
	if self.Transform then
		render2d:WithMatrixMultiplyRight (self.Transform,
			function ()
				self:RenderContents (render2d, resolution / self.TransformL2Norm)
			end
		)
	else
		self:RenderContents (render2d, resolution)
	end
end

-- Internal
function self:RenderContents (render2d, resolution)
	Error ("Element:RenderContents : Not implemented.")
end
