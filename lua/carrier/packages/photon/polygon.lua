local self = {}
Photon.Polygon = Class (self, ICloneable)

function self:ctor ()
	self.PointCount = 0
	self.Xs = {}
	self.Ys = {}
	
	self.BoundsValid = true
	self.MinimumX =  math.huge
	self.MinimumY =  math.huge
	self.MaximumX = -math.huge
	self.MaximumY = -math.huge
end

-- ICloneable
function self:Copy (source)
	for i = 1, source.PointCount do
		self.Xs [i] = source.Xs [i]
		self.Ys [i] = source.Ys [i]
	end
	self.PointCount = source.PointCount
	
	self.BoundsValid = source.BoundsValid
	self.MinimumX = source.MinimumX
	self.MinimumY = source.MinimumY
	self.MaximumX = source.MaximumX
	self.MaximumY = source.MaximumY
end

-- Polygon
function self:AddPoint (x, y)
	self.PointCount = self.PointCount + 1
	self.Xs [self.PointCount] = x
	self.Ys [self.PointCount] = y
	
	self.BoundsValid = false
end

function self:Clear ()
	self.PointCount = 0
	self.BoundsValid = false
end

function self:GetPoint (i)
	return self.Xs [i], self.Ys [i]
end

function self:GetPointCount ()
	return self.PointCount
end

function self:GetBoundingRectangle ()
	if not self.BoundsValid then
		local x0 =  math.huge
		local y0 =  math.huge
		local x1 = -math.huge
		local y1 = -math.huge
		
		for i = 1, self.PointCount do
			x0 = math.min (x0, self.Xs [i])
			x1 = math.max (x1, self.Xs [i])
			y0 = math.min (y0, self.Ys [i])
			y1 = math.max (y1, self.Ys [i])
		end
	end
	
	return self.MinimumX, self.MinimumY, self.MaximumX - self.MinimumX, self.MaximumY - self.MinimumY
end

function self:Rotate (rad, x0, y0)
	local x0, y0 = x0 or 0, y0 or 0
	
	for i = 1, self.PointCount do
		local x, y = self.Xs [i] - x0, self.Ys [i] - y0
		
		local x1 = x * math.cos (rad) - y * math.sin (rad)
		local y1 = x * math.sin (rad) + y * math.cos (rad)
		
		self.Xs [i] = x0 + x1
		self.Ys [i] = y0 + y1
	end
	
	self.BoundsValid = false
end

function self:Translate (dx, dy)
	for i = 1, self.PointCount do
		self.Xs [i] = self.Xs [i] + dx
		self.Ys [i] = self.Ys [i] + dy
	end
	
	self.MinimumX = self.MinimumX + dx
	self.MinimumY = self.MaximumY + dy
	self.MaximumX = self.MinimumX + dx
	self.MaximumY = self.MaximumY + dy
end
