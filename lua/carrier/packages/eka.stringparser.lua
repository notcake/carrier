local OOP = require ("Pylon.OOP")

local self = {}
local StringParser = OOP.Class (self)

function self:ctor (input)
	self.Input    = input
	self.Position = 1
	
	self.PatternCache = {}
end

function self:IsEndOfInput ()
	return self.Position > #self.Input
end

function self:AcceptLiteral (str)
	if string.find (self.Input, str, self.Position, true) then
		self.Position = self.Position + #str
		return str
	else
		return nil
	end
end

function self:AcceptPattern (pattern)
	self.PatternCache [pattern] = self.PatternCache [pattern] or ("^" .. pattern)
	
	local match, nextPosition = string.match (self.Input, self.PatternCache [pattern], self.Position)
	if not match then return nil end
	
	nextPosition = nextPosition or self.Position + #match
	self.Position = nextPosition
	return match
end

function self:AcceptWhitespace ()
	local nextPosition = string.match (self.Input, "^[ \t\r\n]+()", self.Position)
	if not nextPosition then return false end
	
	self.Position = nextPosition
	return true
end
