local self = {}
GraphicsContext = Class (self, IGraphicsContext)

function self:ctor ()
	self.Render2d     = Render2d (self)
	self.Render3d     = Render3d (self)
	self.TextRenderer = TextRenderer ()
end

function self:GetRender2d ()
	return self.Render2d
end

function self:GetRender3d ()
	return self.Render3d
end

function self:GetTextRenderer ()
	return self.TextRenderer
end
