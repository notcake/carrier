local self = {}
Cat.Rings.BigModularRing = Class(self, Cat.Rings.IRing)

function self:ctor(n)
	self.Modulus = n
end

-- Equality
function self:Equals(a, b) return a:Equals(b) end

-- Arithmetic
function self:Add     (a, b, out) return a:Add     (b):Mod(self.Modulus) end
function self:Subtract(a, b, out) return a:Subtract(b):Mod(self.Modulus) end
function self:Multiply(a, b, out) return a:Multiply(b):Mod(self.Modulus) end

function self:Divide(a, b, out)
	return Cat.Rings.ModularRing.Divide(a, b, self.Modulus)
end

function self:Divide(a, b, out)
	local gcd = b:GCD(self.Modulus)
	if gcd:IsOne() then
		return a:Multiply(self:MultiplicativeInverse(b)):Mod(self.Modulus)
	else
		if a:Mod(gcd):IsZero() then
			-- a, b and n all have a shared gcd
			return self:Divide(a:Divide(gcd), b:Divide(gcd), self.Modulus:Divide(gcd))
		else
			return nil
		end
	end
end

-- Identities
function self:AdditiveIdentity      (out) return BigInteger.FromDouble(0) end
function self:MultiplicativeIdentity(out) return BigInteger.FromDouble(1) end

function self:IsAdditiveIdentity      (x) return x:IsZero() end
function self:IsMultiplicativeIdentity(x) return x == BigInteger.FromDouble(1) end

-- Inverses
function self:AdditiveInverse(x, out)
	if x:IsZero() then return x end
	return self.Modulus:Subtract(x)
end

function self:MultiplicativeInverse(x, out)
	return x:ModularInverse(self.Modulus)
end

function self:ToString(x)
	return x:ToDecimal()
end
