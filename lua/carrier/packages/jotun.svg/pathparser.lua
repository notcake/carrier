local self = {}
PathParser = Class (self, StringParser)

function self:ctor (input)
end

function self:AcceptCoordinatePair ()
	local x = self:AcceptNumber () or 0
	self:AcceptCommaWhitespace ()
	local y = self:AcceptNumber () or 0
	return x, y
end

function self:AcceptOptionalCoordinatePair ()
	local x = self:AcceptNumber ()
	if not x then return nil, nil end
	self:AcceptCommaWhitespace ()
	local y = self:AcceptNumber () or 0
	return x, y
end

function self:AcceptNumber ()
	return tonumber (self:AcceptPattern ("[%+%-]?%d*%.?%d*[eE][%+%-]?%d+")) or
	       tonumber (self:AcceptPattern ("[%+%-]?%d*%.?%d*"))
end

function self:AcceptCommaWhitespace ()
	return self:AcceptPattern ("%s*,?%s*")
end
