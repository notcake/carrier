local self = {}
Cat.Rings.UInt64 = Class(self, Cat.Rings.BigModularRing)

function self:ctor()
	self.Modulus = BigInteger.FromHex("010000000000000000")
end

function self:ToString(x)
	return "0x" .. x:ToHex(16)
end

Cat.Rings.UInt64 = Cat.Rings.UInt64()
