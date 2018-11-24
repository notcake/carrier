-- PACKAGE bit.Lua

local bit = {}

function bit.band(a, b) return a & b end
function bit.bor (a, b) return a | b end
function bit.bxor(a, b) return a ~ b end
function bit.bnot(a) return ~a end

function bit.lshift(a, b) return a << b end
function bit.rshift(a, b) return a >> b end

function bit.arshift(a, b)
	local c = a >> b
	if a & 0x80000000 ~= 0 then
		c = c | (0xFFFFFFFF << (32 - b))
	end
	return c
end

function bit.bswap(a)
	return ((a & 0x000000FF) << 24) |
	       ((a & 0x0000FF00) <<  8) |
	       ((a & 0x00FF0000) >>  8) |
	       ((a & 0xFF000000) >> 24)
end

function bit.rol(a, b)
	return (a << b) | (a >> (32 - b))
end

function bit.ror(a, b)
	return (a >> b) | (a << (32 - b))
end

function bit.tobit(a)
	return a & 0xFFFFFFFF
end

function bit.tohex(a, digits)
	return string.format("%0" .. digits .. "x", a)
end

return bit
