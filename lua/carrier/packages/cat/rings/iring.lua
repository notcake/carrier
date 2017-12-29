local self = {}
Cat.Rings.IRing = Class (self)

function self:ctor ()
end

-- Equality
function self:Equals (a, b)
	Error ("IRing:Equals : Not implemented.")
end

-- Arithmetic
function self:Add (a, b, out)
	Error ("IRing:Add : Not implemented.")
end

function self:Subtract (a, b, out)
	return self:Add (a, self:AdditiveInverse (b), out)
end

function self:Multiply (a, b, out)
	Error ("IRing:Multiply : Not implemented.")
end

function self:Divide (a, b, out)
	return self:Multiply (a, self:MultiplicativeInverse (b), out)
end

-- Identities
function self:Zero (out)
	return self:AdditiveIdentity (out)
end

function self:One (out)
	return self:MultiplicativeIdentity (out)
end

function self:IsZero (x)
	return self:IsAdditiveIdentity (x)
end

function self:IsOne (x)
	return self:IsMultiplicativeIdentity (x)
end

-- Identities
function self:AdditiveIdentity (out)
	Error ("IRing:AdditiveIdentity : Not implemented.")
end

function self:MultiplicativeIdentity (out)
	Error ("IRing:MultiplicativeIdentity : Not implemented.")
end

function self:IsAdditiveIdentity (x)
	return self:Equals (self:AdditiveIdentity (), x)
end

function self:IsMultiplicativeIdentity (x)
	return self:Equals (self:MultiplicativeIdentity (), x)
end

-- Inverses
function self:Negate (x, out)
	return self:AdditiveInverse (x, out)
end

function self:Inverse (x, out)
	return self:MultiplicativeInverse (x, out)
end

-- Inverses
function self:AdditiveInverse (x, out)
	Error ("IRing:AdditiveInverse : Not implemented.")
end

function self:MultiplicativeInverse (x, out)
	Error ("IRing:MultiplicativeInverse : Not implemented.")
end

function self:ToString (x)
	Error ("IRing:ToString : Not implemented.")
end

function self:__call ()
	return self
end
