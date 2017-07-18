local self = {}
Core.IGraphicsContext = Interface (self)

function self:ctor ()
end

function self:CreateMesh ()
	Error ("IGraphicsContext:CreateMesh : Not implemented.")
end
