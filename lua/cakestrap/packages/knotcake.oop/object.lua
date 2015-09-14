local self = {}
OOP.Object = OOP.Class (self)

function self:ctor ()
	self.HashCode = nil
end

function self:GetHashCode ()
	if not self.HashCode then
		self.HashCode = string.sub (string.format ("%p", self), 3)
	end
	
	return self.HashCode
end

function self:GetType ()
	return self._Class
end
