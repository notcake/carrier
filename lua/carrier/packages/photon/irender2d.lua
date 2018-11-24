local self = {}
Photon.IRender2d = Interface(self)

function self:ctor()
end

function self:GetGraphicsContext()
	Error("IRender2d:GetGraphicsContext : Not implemented.")
end

function self:GetTextRenderer()
	Error("IRender2d:GetTextRenderer : Not implemented.")
end

function self:DrawLine(color, x1, y1, x2, y2)
	Error("IRender2d:DrawLine : Not implemented.")
end

function self:DrawRectangle(color, x, y, w, h)
	Error("IRender2d:DrawRectangle : Not implemented.")
end

function self:FillRectangle(color, x, y, w, h)
	Error("IRender2d:FillRectangle : Not implemented.")
end

function self:FillConvexPolygon(color, polygon)
	Error("IRender2d:FillConvexPolygon : Not implemented.")
end

function self:FillPolygonEvenOdd(color, polygons, boundingX, boundingY, boundingW, boundingH)
	Error("IRender2d:FillPolygonEvenOdd : Not implemented.")
end

function self:DrawGlyph(color, glyph, x, y)
	Error("IRender2d:DrawGlyph : Not implemented.")
end

-- Transforms
function self:PushMatrix(matrix3x3d)
	Error("IRender2d:PushMatrix : Not implemented.")
end

function self:PushMatrixMultiplyLeft(matrix3x3d)
	Error("IRender2d:PushMatrixMultiplyLeft : Not implemented.")
end

function self:PushMatrixMultiplyRight(matrix3x3d)
	Error("IRender2d:PushMatrixMultiplyRight : Not implemented.")
end

function self:PopMatrix()
	Error("IRender2d:PopMatrix : Not implemented.")
end

function self:WithMatrix(matrix3x3d, f)
	Error("IRender2d:WithMatrix : Not implemented.")
end

function self:WithMatrixMultiplyLeft(matrix3x3d, f)
	Error("IRender2d:WithMatrixMultiplyLeft : Not implemented.")
end

function self:WithMatrixMultiplyRight(matrix3x3d, f)
	Error("IRender2d:WithMatrixMultiplyRight : Not implemented.")
end
