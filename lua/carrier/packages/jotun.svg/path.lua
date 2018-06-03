local self = {}
Svg.Path = Class (self, Svg.Element)

local math_atan2 = math.atan2
local math_cos   = math.cos
local math_max   = math.max
local math_pi    = math.pi
local math_rad   = math.rad
local math_sin   = math.sin
local math_sqrt  = math.sqrt

local Cat_UnpackedMatrix2x2d_VectorMultiply = Cat.UnpackedMatrix2x2d.VectorMultiply
local Cat_UnpackedVector2d_Equals           = Cat.UnpackedVector2d.Equals

function Svg.Path.FromXmlElement (element)
	local path = Svg.Path ()
	
	local fill = element:GetAttribute ("fill") or "#000"
	path:SetFillColor (string.lower (fill) ~= "none" and Color.FromHTMLColor (fill) or nil)
	
	local stroke = element:GetAttribute ("stroke") or "none"
	path:SetStrokeColor (string.lower (stroke) ~= "none" and Color.FromHTMLColor (stroke) or nil)
	
	local d = element:GetAttribute ("d") or ""
	local parser = PathParser (d)
	
	local x0, y0 = 0, 0
	local x, y = 0, 0
	
	parser:AcceptWhitespace ()
	while not parser:IsEndOfInput () do
		local c = parser:AcceptPattern (".")
		parser:AcceptWhitespace ()
		if c == "M" then
			x, y = parser:AcceptCoordinatePair ()
			parser:AcceptCommaWhitespace ()
			
			x0, y0 = x, y
			path:MoveTo (x, y)
			
			local x1, y1 = parser:AcceptOptionalCoordinatePair ()
			while x1 do
				parser:AcceptCommaWhitespace ()
				
				x, y = x1, y1
				path:LineTo (x, y)
				
				x1, y1 = parser:AcceptOptionalCoordinatePair ()
			end
		elseif c == "m" then
			local dx, dy = parser:AcceptCoordinatePair ()
			parser:AcceptCommaWhitespace ()
			
			x, y = x + dx, y + dy
			x0, y0 = x, y
			path:MoveTo (x, y)
			
			dx, dy = parser:AcceptOptionalCoordinatePair ()
			while dx do
				parser:AcceptCommaWhitespace ()
				
				x, y = x + dx, y + dy
				path:LineTo (x, y)
				
				dx, dy = parser:AcceptOptionalCoordinatePair ()
			end
		elseif c == "L" then
			local x1, y1 = parser:AcceptOptionalCoordinatePair ()
			while x1 do
				parser:AcceptCommaWhitespace ()
				
				x, y = x1, y1
				path:LineTo (x, y)
				
				x1, y1 = parser:AcceptOptionalCoordinatePair ()
			end
		elseif c == "l" then
			local dx, dy = parser:AcceptOptionalCoordinatePair ()
			while dx do
				parser:AcceptCommaWhitespace ()
				
				x, y = x + dx, y + dy
				path:LineTo (x, y)
				
				dx, dy = parser:AcceptOptionalCoordinatePair ()
			end
		elseif c == "H" then
			local x1 = parser:AcceptNumber ()
			while x1 do
				parser:AcceptCommaWhitespace ()
				
				x = x1
				path:LineTo (x, y)
				
				x1 = parser:AcceptNumber ()
			end
		elseif c == "h" then
			local dx = parser:AcceptNumber ()
			while dx do
				parser:AcceptCommaWhitespace ()
				
				x = x + dx
				path:LineTo (x, y)
				
				dx = parser:AcceptNumber ()
			end
		elseif c == "V" then
			local y1 = parser:AcceptNumber ()
			while y1 do
				parser:AcceptCommaWhitespace ()
				
				y = y1
				path:LineTo (x, y)
				
				y1 = parser:AcceptNumber ()
			end
		elseif c == "v" then
			local dy = parser:AcceptNumber ()
			while dy do
				parser:AcceptCommaWhitespace ()
				
				y = y + dy
				path:LineTo (x, y)
				
				dy = parser:AcceptNumber ()
			end
		elseif c == "Q" then
			local controlX, controlY = parser:AcceptOptionalCoordinatePair ()
			while controlX do
				parser:AcceptCommaWhitespace ()
				x, y = parser:AcceptCoordinatePair ()
				parser:AcceptCommaWhitespace ()
				
				path:QuadraticBezierCurveTo (x, y, controlX, controlY)
				
				controlX, controlY = parser:AcceptOptionalCoordinatePair ()
			end
		elseif c == "q" then
			local dControlX, dControlY = parser:AcceptOptionalCoordinatePair ()
			while dControlX do
				parser:AcceptCommaWhitespace ()
				local dx, dy = parser:AcceptCoordinatePair ()
				parser:AcceptCommaWhitespace ()
				
				local controlX, controlY = x + dControlX, y + dControlY
				x, y = x + dx, y + dy
				
				path:QuadraticBezierCurveTo (x, y, controlX, controlY)
				
				dControlX, dControlY = parser:AcceptOptionalCoordinatePair ()
			end
		elseif c == "C" then
			local controlX1, controlY1 = parser:AcceptOptionalCoordinatePair ()
			while controlX1 do
				parser:AcceptCommaWhitespace ()
				local controlX2, controlY2 = parser:AcceptCoordinatePair ()
				parser:AcceptCommaWhitespace ()
				x, y = parser:AcceptCoordinatePair ()
				parser:AcceptCommaWhitespace ()
				
				path:CubicBezierCurveTo (x, y, controlX1, controlY1, controlX2, controlY2)
				
				controlX1, controlY1 = parser:AcceptOptionalCoordinatePair ()
			end
		elseif c == "c" then
			local dControlX1, dControlY1 = parser:AcceptOptionalCoordinatePair ()
			while dControlX1 do
				parser:AcceptCommaWhitespace ()
				local dControlX2, dControlY2 = parser:AcceptCoordinatePair ()
				parser:AcceptCommaWhitespace ()
				local dx, dy = parser:AcceptCoordinatePair ()
				parser:AcceptCommaWhitespace ()
				
				local controlX1, controlY1 = x + dControlX1, y + dControlY1
				local controlX2, controlY2 = x + dControlX2, y + dControlY2
				x, y = x + dx, y + dy
				
				path:CubicBezierCurveTo (x, y, controlX1, controlY1, controlX2, controlY2)
				
				dControlX1, dControlY1 = parser:AcceptOptionalCoordinatePair ()
			end
		elseif c == "T" then
			x, y = parser:AcceptCoordinatePair ()
			
			path:ContinueQuadraticBezierCurveTo (x, y)
		elseif c == "t" then
			local dx, dy = parser:AcceptCoordinatePair ()
			
			x, y = x + dx, y + dy
			path:ContinueQuadraticBezierCurveTo (x, y)
		elseif c == "S" then
			local controlX2, controlY2 = parser:AcceptCoordinatePair ()
			parser:AcceptCommaWhitespace ()
			x, y = parser:AcceptCoordinatePair ()
			
			path:ContinueCubicBezierCurveTo (x, y, controlX2, controlY2)
		elseif c == "s" then
			local dControlX2, dControlY2 = parser:AcceptCoordinatePair ()
			parser:AcceptCommaWhitespace ()
			local dx, dy = parser:AcceptCoordinatePair ()
			
			local controlX2, controlY2 = x + dControlX2, y + dControlY2
			x, y = x + dx, y + dy
			path:ContinueCubicBezierCurveTo (x, y, controlX2, controlY2)
		elseif c == "A" then
			local rx = parser:AcceptNumber ()
			while rx do
				parser:AcceptCommaWhitespace ()
				local ry = parser:AcceptNumber () or 0
				parser:AcceptCommaWhitespace ()
				local angle = parser:AcceptNumber () or 0
				parser:AcceptCommaWhitespace ()
				local largerArc = tonumber (parser:AcceptPattern ("[01]")) ~= 0
				parser:AcceptCommaWhitespace ()
				local clockwise = tonumber (parser:AcceptPattern ("[01]")) ~= 0
				parser:AcceptCommaWhitespace ()
				x, y = parser:AcceptCoordinatePair ()
				parser:AcceptCommaWhitespace ()
				
				path:ArcTo (x, y, rx, ry, angle, largerArc, clockwise)
				
				rx = parser:AcceptNumber ()
			end
		elseif c == "a" then
			local rx = parser:AcceptNumber ()
			while rx do
				parser:AcceptCommaWhitespace ()
				local ry = parser:AcceptNumber () or 0
				parser:AcceptCommaWhitespace ()
				local angle = parser:AcceptNumber () or 0
				parser:AcceptCommaWhitespace ()
				local largerArc = tonumber (parser:AcceptPattern ("[01]")) ~= 0
				parser:AcceptCommaWhitespace ()
				local clockwise = tonumber (parser:AcceptPattern ("[01]")) ~= 0
				parser:AcceptCommaWhitespace ()
				local dx, dy = parser:AcceptCoordinatePair ()
				parser:AcceptCommaWhitespace ()
				
				x, y = x + dx, y + dy
				path:ArcTo (x, y, rx, ry, angle, largerArc, clockwise)
				
				rx = parser:AcceptNumber ()
			end
		elseif c == "Z" or
		       c == "z" then
			path:ClosePath ()
		else
			-- ???
			assert (false, "\"" .. c .. "\"")
		end
		
		parser:AcceptWhitespace ()
	end
	
	return path
end

function self:ctor ()
	self.StrokeColor = nil
	self.FillColor   = Color.Black
	
	self.PathCommands  = {}
	self.PathArguments = {}
end

-- Element
function self:Render (render2d, x, y)
	local dx, dy = x, y
	local ds = 1
	if self.FillColor ~= nil then
		if not self.Polygons then
			local polygonCount = 0
			self.Polygons = self.Polygons or {}
			local polygon = nil
			local x0, y0 = 0, 0
			local lastX, lastY = 0, 0
			for command, x, y, cx1, cy1, cx2, cy2, clockwise in self:GetEnumerator () do
				if command == Svg.PathCommand.MoveTo then
					polygonCount = polygonCount + 1
					polygon = self.Polygons [polygonCount] or Photon.Polygon ()
					polygon:Clear ()
					self.Polygons [polygonCount] = polygon
					polygon:AddPoint (x, y)
					x0, y0 = x, y
				elseif command == Svg.PathCommand.LineTo then
					if not polygon then
						polygonCount = polygonCount + 1
						polygon = self.Polygons [polygonCount] or Photon.Polygon ()
						polygon:Clear ()
						self.Polygons [polygonCount] = polygon
						polygon:AddPoint (x0, y0)
					end
					
					polygon:AddPoint (x, y)
				elseif command == Svg.PathCommand.QuadraticBezierCurveTo then
					if not polygon then
						polygonCount = polygonCount + 1
						polygon = self.Polygons [polygonCount] or Photon.Polygon ()
						polygon:Clear ()
						self.Polygons [polygonCount] = polygon
						polygon:AddPoint (x0, y0)
					end
					
					Cat.UnpackedQuadraticBezier2d.Approximate (lastX, lastY, cx1, cy1, x, y, ds,
						function (x, y)
							if Cat_UnpackedVector2d_Equals (x, y, lastX, lastY) then return end
							
							polygon:AddPoint (x, y)
						end
					)
				elseif command == Svg.PathCommand.CubicBezierCurveTo then
					if not polygon then
						polygonCount = polygonCount + 1
						polygon = self.Polygons [polygonCount] or Photon.Polygon ()
						polygon:Clear ()
						self.Polygons [polygonCount] = polygon
						polygon:AddPoint (x0, y0)
					end
					
					Cat.UnpackedCubicBezier2d.Approximate (lastX, lastY, cx1, cy1, cx2, cy2, x, y, ds,
						function (x, y)
							if Cat_UnpackedVector2d_Equals (x, y, lastX, lastY) then return end
							
							polygon:AddPoint (x, y)
						end
					)
				elseif command == Svg.PathCommand.ArcTo then
					if not polygon then
						polygonCount = polygonCount + 1
						polygon = self.Polygons [polygonCount] or Photon.Polygon ()
						polygon:Clear ()
						self.Polygons [polygonCount] = polygon
						polygon:AddPoint (x0, y0)
					end
					
					local rx, ry = cx1, cy1
					local angle, largerArc = math_rad (cx2), cy2
					
					-- Forward matrix from normalized circle space to canvas
					-- R S
					local f00, f01, f10, f11 = rx * math_cos (angle), -ry * math_sin (angle),
					                           rx * math_sin (angle),  ry * math_cos (angle)
					-- Reverse matrix from canvas to normalized circle space
					-- S^-1 R^-1
					local r00, r01, r10, r11 =  1 / rx * math_cos (angle), 1 / rx * math_sin (angle),
					                           -1 / ry * math_sin (angle), 1 / ry * math_cos (angle)
					
					-- Arc is from (0, 0) to (x1, y1) in normalized circle space
					local x1, y1 = Cat_UnpackedMatrix2x2d_VectorMultiply (r00, r01, r10, r11, x - lastX, y - lastY)
					local dSquared = x1 * x1 + y1 * y1
					
					-- Compute circle center, using (x1, y1) rotated clockwise
					local k = math_sqrt (math_max (0, 1 / dSquared - 0.25))
					local dx, dy = -k * y1, k * x1
					local cx, cy
					if largerArc ~= clockwise then
						cx, cy = 0.5 * x1 + dx, 0.5 * y1 + dy
					else
						cx, cy = 0.5 * x1 - dx, 0.5 * y1 - dy
					end
					
					-- Compute start and end angles
					local θ0 = math_atan2 (-cy, -cx)
					local θ1 = math_atan2 (y1 - cy, x1 - cx)
					local dθ = ds / math_max (rx, ry)
					if clockwise then
						if θ1 < θ0 then
							θ1 = θ1 + 2 * math_pi
						end
					else
						dθ = -dθ
						if θ1 > θ0 then
							θ1 = θ1 - 2 * math_pi
						end
					end
					
					-- Sweep
					for θ = θ0 + dθ, θ1, dθ do
						local x, y = cx + math_cos (θ), cy + math_sin (θ)
						x, y = Cat_UnpackedMatrix2x2d_VectorMultiply (f00, f01, f10, f11, x, y)
						
						polygon:AddPoint (lastX + x, lastY + y)
					end
					
					polygon:AddPoint (x, y)
				elseif command == Svg.PathCommand.ClosePath then
					polygon = nil
				else
					if not polygon then
						polygonCount = polygonCount + 1
						polygon = self.Polygons [polygonCount] or Photon.Polygon ()
						polygon:Clear ()
						self.Polygons [polygonCount] = polygon
						polygon:AddPoint (x0, y0)
					end
					
					polygon:AddPoint (x, y)
				end
				
				lastX, lastY = x, y
			end
			
			for i = #self.Polygons, polygonCount + 1, -1 do
				self.Polygons [i] = nil
			end
			
			if dx ~= 0 or dy ~= 0 then
				for i = 1, #self.Polygons do
					self.Polygons [i]:Translate (dx, dy)
				end
			end
		end
		
		render2d:FillPolygonEvenOdd (self.FillColor, self.Polygons)
	end
	
	if self.StrokeColor ~= nil then
	end
end

-- Path
function self:GetFillColor ()
	return self.FillColor
end

function self:GetStrokeColor ()
	return self.StrokeColor
end

function self:SetFillColor (fillColor)
	self.FillColor = fillColor
end

function self:SetStrokeColor (strokeColor)
	self.StrokeColor = strokeColor
end

-- Path
function self:GetEnumerator ()
	local i = 0
	local j = 1
	return function ()
		i = i + 1
		local command = self.PathCommands [i]
		if not command then return nil end
		
		if command == Svg.PathCommand.MoveTo or
		   command == Svg.PathCommand.LineTo or
		   command == Svg.PathCommand.ContinueQuadraticBezierCurveTo then
			local x, y = self.PathArguments [j], self.PathArguments [j + 1]
			j = j + 2
			return command, x, y
		elseif command == Svg.PathCommand.QuadraticBezierCurveTo then
			local x, y = self.PathArguments [j], self.PathArguments [j + 1]
			local controlX, controlY = self.PathArguments [j + 2], self.PathArguments [j + 3]
			j = j + 4
			return command, x, y, controlX, controlY
		elseif command == Svg.PathCommand.CubicBezierCurveTo then
			local x, y = self.PathArguments [j], self.PathArguments [j + 1]
			local controlX1, controlY1 = self.PathArguments [j + 2], self.PathArguments [j + 3]
			local controlX2, controlY2 = self.PathArguments [j + 4], self.PathArguments [j + 5]
			j = j + 6
			return command, x, y, controlX1, controlY1, controlX2, controlY2
		elseif command == Svg.PathCommand.ContinueCubicBezierCurveTo then
			local x, y = self.PathArguments [j], self.PathArguments [j + 1]
			local controlX2, controlY2 = self.PathArguments [j + 2], self.PathArguments [j + 3]
			j = j + 4
			return command, x, y, controlX2, controlY2
		elseif command == Svg.PathCommand.ArcTo then
			local x, y = self.PathArguments [j], self.PathArguments [j + 1]
			local rx, ry = self.PathArguments [j + 2], self.PathArguments [j + 3]
			local angle, largerArc, clockwise = self.PathArguments [j + 4], self.PathArguments [j + 5], self.PathArguments [j + 6]
			j = j + 7
			return command, x, y, rx, ry, angle, largerArc, clockwise
		elseif command == Svg.PathCommand.ClosePath then
			return command
		end
	end
end

function self:MoveTo (x, y)
	self.PathCommands [#self.PathCommands + 1] = Svg.PathCommand.MoveTo
	self.PathArguments [#self.PathArguments + 1] = x
	self.PathArguments [#self.PathArguments + 1] = y
end

function self:LineTo (x, y)
	self.PathCommands [#self.PathCommands + 1] = Svg.PathCommand.LineTo
	self.PathArguments [#self.PathArguments + 1] = x
	self.PathArguments [#self.PathArguments + 1] = y
end

function self:QuadraticBezierCurveTo (x, y, controlX, controlY)
	self.PathCommands [#self.PathCommands + 1] = Svg.PathCommand.QuadraticBezierCurveTo
	self.PathArguments [#self.PathArguments + 1] = x
	self.PathArguments [#self.PathArguments + 1] = y
	self.PathArguments [#self.PathArguments + 1] = controlX
	self.PathArguments [#self.PathArguments + 1] = controlY
end

function self:ContinueQuadraticBezierCurveTo (x, y)
	self.PathCommands [#self.PathCommands + 1] = Svg.PathCommand.ContinueQuadraticBezierCurveTo
	self.PathArguments [#self.PathArguments + 1] = x
	self.PathArguments [#self.PathArguments + 1] = y
end

function self:CubicBezierCurveTo (x, y, controlX1, controlY1, controlX2, controlY2)
	self.PathCommands [#self.PathCommands + 1] = Svg.PathCommand.CubicBezierCurveTo
	self.PathArguments [#self.PathArguments + 1] = x
	self.PathArguments [#self.PathArguments + 1] = y
	self.PathArguments [#self.PathArguments + 1] = controlX1
	self.PathArguments [#self.PathArguments + 1] = controlY1
	self.PathArguments [#self.PathArguments + 1] = controlX2
	self.PathArguments [#self.PathArguments + 1] = controlY2
end

function self:ContinueCubicBezierCurveTo (x, y, controlX2, controlY2)
	self.PathCommands [#self.PathCommands + 1] = Svg.PathCommand.ContinueCubicBezierCurveTo
	self.PathArguments [#self.PathArguments + 1] = x
	self.PathArguments [#self.PathArguments + 1] = y
	self.PathArguments [#self.PathArguments + 1] = controlX2
	self.PathArguments [#self.PathArguments + 1] = controlY2
end

function self:ArcTo (x, y, rx, ry, angle, largerArc, clockwise)
	self.PathCommands [#self.PathCommands + 1] = Svg.PathCommand.ArcTo
	self.PathArguments [#self.PathArguments + 1] = x
	self.PathArguments [#self.PathArguments + 1] = y
	self.PathArguments [#self.PathArguments + 1] = rx
	self.PathArguments [#self.PathArguments + 1] = ry
	self.PathArguments [#self.PathArguments + 1] = angle
	self.PathArguments [#self.PathArguments + 1] = largerArc
	self.PathArguments [#self.PathArguments + 1] = clockwise
end

function self:ClosePath ()
	self.PathCommands [#self.PathCommands + 1] = Svg.PathCommand.ClosePath
end
