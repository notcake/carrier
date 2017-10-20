local self = {}
Cat.GF2Matrix = Class (self)

function Cat.GF2Matrix.Identity (size)
	local m = Cat.GF2Matrix (size, size)
	for i = 0, size - 1 do
		m [i * size + i] = 1
	end
end

function Cat.GF2Matrix.Zero (h, w)
	return Cat.GF2Matrix (h, w)
end

function Cat.GF2Matrix.ColumnFromUInt32 (x, out)
	local out = out or Cat.GF2Matrix (0, 0)
	out.w, out.h = 1, 32
	for i = 1, 32 do
		local b = x % 2
		out [i - 1] = b
		x = (x - b) * 0.5
	end
	return out
end

function Cat.GF2Matrix.RowFromUInt32 (x, out)
	local out = out or Cat.GF2Matrix (0, 0)
	out.w, out.h = 32, 1
	for i = 1, 32 do
		local b = x % 2
		out [i - 1] = b
		x = (x - b) * 0.5
	end
	return out
end

function self:ctor (h, w, ...)
	self.h = h
	self.w = w
	for i = 0, w * h - 1 do
		self [i] = 0
	end
	
	if ... then
		local elements = {...}
		for i = 1, math.min (self.w * self.h, #elements) do
			self [i - 1] = elements [i]
		end
	end
end

function self:Clone (out)
	if rawequal (out, self) then return self end
	
	local out = out or Cat.GF2Matrix (0, 0)
	out.w, out.h = self.w, self.h
	for i = 0, self.w * self.h - 1 do
		out [i] = self [i]
	end
	return out
end

function self:Equals (b)
	local a = self
	if a.w ~= b.w then return false end
	if a.h ~= b.h then return false end
	
	for i = 0, a.w * a.h - 1 do
		if a [i] ~= b [i] then return false end
	end
	
	return true
end

-- Elements
function self:Get (y, x)
	return self [y * self.w + x]
end

function self:Set (y, x, value)
	self [y * self.w + x] = value
end

-- Arithmetic
function self:Add (b, out)
	local a = self
	assert (a.w == b.w)
	assert (a.h == b.h)
	
	local out = out or Cat.GF2Matrix (0, 0)
	out.w, out.h = a.w, a.h
	
	for i = 0, a.w * a.h - 1 do
		out [i] = a [i] * (1 - b [i]) + (1 - a [i]) * b [i]
	end
	return out
end

function self:Subtract (b, out)
	return self:Add (b, out)
end

function self:Multiply (b, out)
	local a = self
	assert (a.w == b.h)
	
	local out = out or Cat.GF2Matrix (0, 0)
	out.w, out.h = b.w, a.h
	for y = 0, a.h - 1 do
		for x = 0, b.w - 1 do
			local sum = 0
			for k = 0, a.w - 1 do
				sum = sum + a [y * a.w + k] * b [k * b.w + x]
			end
			out [y * out.w + x] = sum % 2
		end
	end
	
	return out
end

function self:Negate (out)
	return out and self:Clone (out) or self
end

-- Matrix operations
function self:Invert (out)
	assert (self.w == self.h)
	
	local out = out or Cat.GF2Matrix (0, 0)
	out.w, out.h = self.w, self.h
	
	local rref = Cat.GF2Matrix (0, 0)
	rref.w, rref.h = self.w * 2, self.h
	
	-- rref = [self 0]
	for y = 0, self.h - 1 do
		for x = 0, self.w - 1 do
			rref [y * rref.w + x] = self [y * self.w + x]
			rref [y * rref.w + self.w + x] = 0
		end
	end
	
	-- Fill diagonal with 1s
	for i = 0, self.w - 1 do
		rref [i * rref.w + self.w + i] = 1
	end
	
	rref = rref:ReducedRowEchelonForm (rref)
	
	-- rref = [I self^-1]
	for y = 0, out.h - 1 do
		for x = 0, out.w - 1 do
			out [y * out.w + x] = rref [y * rref.w + self.w + x]
		end
	end
	
	return out
end

function self:NullSpace ()
	-- Assume we are already in reduced row echelon form
	local nullSpace = {}
	local xs = {}
	
	local y = 0
	for x = 0, self.w - 1 do
		if y < self.h and self [y * self.w + x] ~= 0 then
			-- Found a 1
			xs [y] = x
			y = y + 1
		else
			local v = Cat.GF2Matrix (self.w, 1)
			for y0 = 0, y - 1 do
				v [xs [y0]] = self [y0 * self.w + x]
			end
			v [x] = 1
			nullSpace [#nullSpace + 1] = v
		end
	end
	
	return nullSpace
end

function self:ReducedRowEchelonForm (out)
	local out = self:Clone (out)
	
	local x = 0
	for y = 0, out.h - 1 do
		while x < out.w do
			-- Ensure row y starts with a 1
			if out [y * out.w + x] == 0 then
				-- Find a row with non-zero element x to borrow
				for y1 = y + 1, out.h - 1 do
					if out [y1 * out.w + x] ~= 0 then
						-- Found one
						-- Add row y1 to row y
						for x = x, out.w - 1 do
							out [y * out.w + x] = out [y * out.w + x] * (1 - out [y1 * out.w + x]) + (1 - out [y * out.w + x]) * out [y1 * out.w + x]
						end
						break
					end
				end
			end
			
			if out [y * out.w + x] ~= 0 then
				-- Now use row y to clear element x of all the other rows
				for y1 = 0, out.h - 1 do
					if y1 ~= y then
						if out [y1 * out.w + x] ~= 0 then
							-- Add row y to row y1
							for x = x, out.w - 1 do
								out [y1 * out.w + x] = out [y1 * out.w + x] * (1 - out [y * out.w + x]) + (1 - out [y1 * out.w + x]) * out [y * out.w + x]
							end
						end
					end
				end
				
				x = x + 1
				break
			else
				-- Failed, try next column
				x = x + 1
			end
		end
	end
	
	return out
end

function self:Solve (b, out)
	assert (b.w == 1)
	assert (self.h == b.h)
	
	local out = out or Cat.GF2Matrix (0, 0)
	out.w, out.h = self.w, self.h
	
	local rref = Cat.GF2Matrix (0, 0)
	rref.w, rref.h = self.w + 1, self.h
	
	-- rref = [self b]
	for y = 0, self.h - 1 do
		for x = 0, self.w - 1 do
			rref [y * rref.w + x] = self [y * self.w + x]
			rref [y * rref.w + self.w + x] = 0
		end
		
		rref [y * rref.w + self.w] = b [y]
	end
	
	rref = rref:ReducedRowEchelonForm (rref)
	
	-- Find first solution and null space
	local x0 = Cat.GF2Matrix (self.w, 1)
	local nullSpace = {}
	local xs = {}
	
	local y = 0
	for x = 0, rref.w - 2 do
		if y < rref.h and rref [y * rref.w + x] ~= 0 then
			-- Found a 1
			xs [y] = x
			x0 [x] = rref [y * rref.w + self.w]
			
			y = y + 1
		else
			-- Null space vector
			local v = Cat.GF2Matrix (rref.w - 1, 1)
			for y0 = 0, y - 1 do
				v [xs [y0]] = rref [y0 * rref.w + x]
			end
			v [x] = 1
			nullSpace [#nullSpace + 1] = v
		end
	end
	
	for y = y, rref.h - 1 do
		if rref [y * rref.w + self.w] ~= 0 then return nil, nullSpace end
	end
	
	return x0, nullSpace
end

function self:Transpose (out)
	local out = out or Cat.GF2Matrix (0, 0)
	out.w, out.h = self.h, self.w
	
	for y = 0, self.h - 1 do
		for x = 0, self.w - 1 do
			out [x * out.w + y] = self [y * self.w + x];
		end
	end
	
	return out
end

-- Rows and columns
function self:GetColumn (x, out)
	local out = out or Cat.GF2Matrix (0, 0)
	out.w, out.h = 1, self.h
	
	for y = 0, self.h - 1 do
		out [y] = self [y * self.w + x]
	end
	
	return out
end

function self:GetRow (y, out)
	local out = out or Cat.GF2Matrix (0, 0)
	out.w, out.h = self.w, 1
	
	for x = 0, self.w - 1 do
		out [x] = self [y * self.w + x]
	end
	
	return out
end

function self:SetColumn (x, column)
	assert (column.w == 1)
	assert (self.h == column.h)
	
	for y = 0, self.h - 1 do
		self [y * self.w + x] = column [y]
	end
	
	return self
end

function self:SetRow (y, row)
	assert (row.h == 1)
	assert (self.w == row.w)
	
	for x = 0, self.w - 1 do
		self [y * self.w + x] = row [x]
	end
	
	return self
end

-- Conversions
function self:ColumnToUInt32 ()
	assert (self.w ==  1)
	assert (self.h == 32)
	
	local x = 0
	for i = 31, 0, -1 do
		x = x * 2 + self [i]
	end
	
	return x
end

function self:RowToUInt32 ()
	assert (self.w == 32)
	assert (self.h ==  1)
	
	local x = 0
	for i = 31, 0, -1 d
		x = x * 2 + self [i]
	end
	
	return x
end

function self:ToString ()
	local rows = {}
	for y = 0, self.h - 1 do
		local column = {}
		for x = 0, self.w - 1 do
			column [#column + 1] = self [y * self.w + x]
		end
		
		rows [#rows + 1] = "[ " .. table.concat (column) .. " ]"
	end
	
	return table.concat (rows, "\n")
end

self.__eq  = self.Equals
self.__add = self.Add
self.__sub = self.Subtract
self.__mul = self.Multiply
self.__unm = self.Negate
self.__tostring = self.ToString
