local self = {}
Cat.Rings.ModularRing = Class(self, Cat.Rings.IRing)

function Cat.Rings.ModularRing.Divide(a, b, n)
	local quotient = a / b
	if math.floor(quotient) == quotient then return quotient end
	
	local gcd = Cat.Rings.ModularRing.GCD(b, n)
	if gcd == 1 then
		return (a * Cat.Rings.ModularRing.MultiplicativeInverse(b, n)) % n
	else
		if a % gcd == 0 then
			-- a, b and n all have a shared gcd
			return Cat.Rings.ModularRing.Divide(a / gcd, b / gcd, n / gcd)
		else
			return nil
		end
	end
end

function Cat.Rings.ModularRing.GCD(a, b)
	while b ~= 0 do
		a, b = b, a % b
	end
	
	return a
end

function Cat.Rings.ModularRing.MultiplicativeInverse(x, n)
	local a, b = n, x
	local previousR, r = a, b
	local previousT, t = 0, 1
	
	-- a s_0 + b t_0 = r_0 = a => s_0 = 1, t_0 = 0
	-- a s_1 + b t_1 = r_1 = b => s_1 = 0, t_1 = 1
	
	-- r_i+1 = r_i-1 - r_i q_i
	--       = (a s_i-1 + b t_i-1) - (a s_i + b t_i) q_i
	--       = (a s_i-1 - a s_i q_i) + (b t_i-1 - b t_i q_i)
	--       = a (s_i-1 - s_i q_i) + b (t_i-1 - t_i q_i)
	while r ~= 0 do
		local q = math.floor(previousR / r)
		previousR, r = r, previousR % r
		
		-- s_i+1 = s_i-1 - s_i q_i
		-- t_i+1 = t_i-1 - t_i q_i
		previousT, t = t, previousT - t * q
	end
	
	-- r_i = gcd(x, n)
	-- r_i+1 == 0
	
	-- gcd must be 1 for there to be an inverse
	if previousR > 1 then return nil end
	
	-- Return normalized inverse
	return previousT < 0 and previousT + n or previousT
end

Cat.Rings.ModularRing.Inverse = Cat.Rings.ModularRing.MultiplicativeInverse

function self:ctor(n)
	self.Modulus = n
end

-- Equality
function self:Equals(a, b) return a == b end

-- Arithmetic
function self:Add     (a, b, out) return (a + b) % self.Modulus end
function self:Subtract(a, b, out) return (a - b) % self.Modulus end
function self:Multiply(a, b, out) return (a * b) % self.Modulus end

function self:Divide(a, b, out)
	return Cat.Rings.ModularRing.Divide(a, b, self.Modulus)
end

-- Identities
function self:AdditiveIdentity      (out) return 0 end
function self:MultiplicativeIdentity(out) return 1 end

function self:IsAdditiveIdentity      (x) return x == 0 end
function self:IsMultiplicativeIdentity(x) return x == 1 end

-- Inverses
function self:AdditiveInverse(x, out)
	return -x % self.Modulus
end

function self:MultiplicativeInverse(x, out)
	return Cat.Rings.ModularRing.MultiplicativeInverse(x, self.Modulus)
end

function self:ToString(x)
	return tostring(x)
end
