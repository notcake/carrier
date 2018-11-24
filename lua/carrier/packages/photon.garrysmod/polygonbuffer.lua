local self = {}
PolygonBuffer = Class(self)

function self:ctor()
	self.PointCount = 0
	self.Buffer = {}
	
	self.Temporary = nil
end

function self:GetBuffer()
	return self.Buffer
end

function self:Bind(polygon)
	local pointCount = polygon:GetPointCount()
	
	-- Resize
	for i = #self.Buffer + 1, pointCount do
		self.Buffer[i] = { x = 0, y = 0 }
	end
	
	-- Bind
	self.PointCount = pointCount
	for i = 1, pointCount do
		self.Buffer[i].x, self.Buffer[i].y = polygon:GetPoint(i)
	end
	
	self.Temporary = self.Buffer[self.PointCount + 1]
	self.Buffer[self.PointCount + 1] = nil
end

function self:Unbind()
	self.Buffer[self.PointCount + 1] = self.Temporary
	self.Temporary = nil
end
