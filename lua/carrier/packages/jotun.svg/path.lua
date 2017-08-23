local self = {}
Svg.Path = Class (self, Svg.Element)

function Svg.Path.FromXmlElement (element)
	local path = Svg.Path ()
	
	local fill = element:GetAttribute ("fill") or "#000"
	path:SetFillColor (string.lower (fill) ~= "none" and Color.FromHTMLColor (fill) or nil)
	
	local stroke = element:GetAttribute ("stroke") or "none"
	path:SetStrokeColor (string.lower (stroke) ~= "none" and Color.FromHTMLColor (stroke) or nil)
	
	local d = element:GetAttribute ("d") or ""
	local parser = StringParser (d)
	
	local x0, y0 = 0, 0
	local x, y = 0, 0
	
	parser:AcceptWhitespace ()
	while not parser:IsEndOfInput () do
		local c = parser:AcceptPattern (".")
		parser:AcceptWhitespace ()
		if c == "M" then
			x = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			y = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			
			x0, y0 = x, y
			path:MoveTo (x, y)
		elseif c == "m" then
			local dx = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local dy = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			
			x, y = x + dx, y + dy
			x0, y0 = x, y
			path:MoveTo (x, y)
		elseif c == "L" then
			x = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			y = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			
			path:LineTo (x, y)
		elseif c == "l" then
			local dx = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local dy = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			
			x, y = x + dx, y + dy
			path:LineTo (x, y)
		elseif c == "H" then
			x = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			
			path:LineTo (x, y)
		elseif c == "h" then
			local dx = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			
			x = x + dx
			path:LineTo (x, y)
		elseif c == "V" then
			y = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			
			path:LineTo (x, y)
		elseif c == "v" then
			local dy = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			
			y = y + dy
			path:LineTo (x, y)
		elseif c == "Q" then
			local controlX = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local controlY = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			x = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			y = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			
			path:QuadraticBezierCurveTo (x, y, controlX, controlY)
		elseif c == "q" then
			local dControlX = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local dControlY = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local dx = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local dy = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			
			local controlX, controlY = x + dControlX, y + dControlY
			x, y = x + dx, y + dy
			path:QuadraticBezierCurveTo (x, y, controlX, controlY)
		elseif c == "C" then
			local controlX1 = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local controlY1 = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local controlX2 = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local controlY2 = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			x = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			y = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			
			path:CubicBezierCurveTo (x, y, controlX1, controlY1, controlX2, controlY2)
		elseif c == "c" then
			local dControlX1 = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local dControlY1 = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local dControlX2 = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local dControlY2 = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local dx = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local dy = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			
			local controlX1, controlY1 = x + dControlX1, y + dControlY1
			local controlX2, controlY2 = x + dControlX2, y + dControlY2
			x, y = x + dx, y + dy
			path:CubicBezierCurveTo (x, y, controlX1, controlY1, controlX2, controlY2)
		elseif c == "T" then
			x = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			y = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			
			path:ContinueQuadraticBezierCurveTo (x, y)
		elseif c == "t" then
			local dx = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local dy = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			
			x, y = x + dx, y + dy
			path:ContinueQuadraticBezierCurveTo (x, y)
		elseif c == "S" then
			local controlX2 = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local controlY2 = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			x = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			y = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			
			path:CubicBezierCurveTo (x, y, controlX2, controlY2)
		elseif c == "s" then
			local dControlX2 = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local dControlY2 = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local dx = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local dy = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			
			local controlX2, controlY2 = x + dControlX2, y + dControlY2
			x, y = x + dx, y + dy
			path:CubicBezierCurveTo (x, y, controlX2, controlY2)
		elseif c == "A" then
			local rx = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local ry = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local angle = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local largerArc = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) ~= 0
			parser:AcceptPattern ("[%s,]*")
			local clockwise = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) ~= 0
			parser:AcceptPattern ("[%s,]*")
			x = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			y = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			
			path:ArcTo (x, y, rx, ry, angle, largerArc, clockwise)
		elseif c == "a" then
			local rx = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local ry = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local angle = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local largerArc = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) ~= 0
			parser:AcceptPattern ("[%s,]*")
			local clockwise = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) ~= 0
			parser:AcceptPattern ("[%s,]*")
			local dx = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			parser:AcceptPattern ("[%s,]*")
			local dy = tonumber (parser:AcceptPattern ("%-?%d*%.?%d*")) or 0
			
			x, y = x + dx, y + dy
			path:ArcTo (x, y, rx, ry, angle, largerArc, clockwise)
		elseif c == "Z" then
			path:ClosePath ()
		elseif c == "z" then
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
	if self.FillColor ~= nil then
		local polygon = nil
		local x0, y0 = 0, 0
		for command, x, y in self:GetEnumerator () do
			if command == Svg.PathCommand.MoveTo then
				if polygon then
					render2d:FillConvexPolygon (self.FillColor, polygon)
				end
				
				polygon = Photon.Polygon ()
				polygon:AddPoint (x, y)
				x0, y0 = x, y
			elseif command == Svg.PathCommand.LineTo then
				if not polygon then
					polygon = Photon.Polygon ()
					polygon:AddPoint (x0, y0)
				end
				
				polygon:AddPoint (x, y)
			elseif command == Svg.PathCommand.ClosePath then
				if polygon then
					render2d:FillConvexPolygon (self.FillColor, polygon)
				end
				
				polygon = nil
			else
				if not polygon then
					polygon = Photon.Polygon ()
					polygon:AddPoint (x0, y0)
				end
				
				polygon:AddPoint (x, y)
			end
		end
		
		if polygon then
			render2d:FillConvexPolygon (self.FillColor, polygon)
		end
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
