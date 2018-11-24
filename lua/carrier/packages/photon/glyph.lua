local self = {}
Photon.Glyph = Class(self)

function self:ctor(width, height, renderer)
	self.Width  = width
	self.Height = height
	
	self.Renderer = renderer
end

function self:GetSize()
	return self.Width, self.Height
end

function self:GetWidth()
	return self.Width
end

function self:GetHeight()
	return self.Height
end

function self:Render(render2d, color)
	self.Renderer(render2d, color)
end
