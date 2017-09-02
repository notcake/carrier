local OOP    = require ("Pylon.OOP")
local UInt24 = require ("Pylon.UInt24")

local self = {}
local BigInteger = OOP.Class (self)

local tonumber      = tonumber

local bit_band      = bit.band
local bit_rshift    = bit.rshift
local math_max      = math.max
local string_format = string.format
local string_sub    = string.sub
local table_concat  = table.concat

function BigInteger.FromDecimal (str)
	local n = BigInteger ()
	
	-- Convert to decimal digit array
	local d = {}
	for i = #str, 1, -1 do
		d [#d + 1] = string_sub (str, i, i)
	end
	
	-- Normalize
	for i = #d, 1, -1 do
		if d [i] ~= 0 then break end
		
		d [i] = nil
	end
	
	-- Pull off powers of 2
	local factor = 1
	while #d > 0 do
		if factor == 0x01000000 then
			factor = 1
			n [#n + 1] = 0
		end
		
		-- Pull off bit
		if d [1] % 2 == 1 then
			d [1] = d [1] - 1
			n [#n] = n [#n] + factor
		end
		
		-- Divide d by 2
		for i = 1, #d do
			if d [i] % 2 == 1 then
				d [i] = d [i] - 1
				d [i - 1] = d [i - 1] + 5
			end
			d [i] = d [i] / 2
		end
		
		-- Normalize
		if d [#d] == 0 then
			d [#d] = nil
		end
		
		factor = factor * 2
	end
	
	return n
end

function BigInteger.FromHex (str)
	local n = BigInteger ()
	
	n [1] = nil
	for i = #str - 5, 1, -6 do
		n [#n + 1] = tonumber (string_sub (str, i, i + 5), 16)
	end
	
	if #str % 6 ~= 0 then
		n [#n + 1] = tonumber (string_sub (str, 1, #str % 6), 16)
	end
	
	-- Normalize
	for i = #n, 2, -1 do
		if n [i] ~= 0 then break end
		
		n [i] = nil
	end
	
	return n
end

function BigInteger.FromUInt8 (x)
	local n = BigInteger ()
	n [1] = x
	return n
end

function BigInteger.FromUInt32 (x)
	local n = BigInteger ()
	n [1] = bit_band (x, 0x00FFFFFF)
	n [2] = bit_rshift (x, 24)
	n [2] = n [2] ~= 0 and n [2] or nil
	return n
end

function self:ctor ()
	self [1] = 0
end

function self:Add (b, out)
	local out = out or BigInteger ()
	local a = self
	
	if #b > #a then
		a, b = b, a
	end
	
	local cf = 0
	for i = 1, #b do
		out [i], cf = UInt24.AddWithCarry (a [i], b [i], cf)
	end
	
	for i = #b + 1, #a do
		out [i], cf = UInt24.Add (a [i], cf)
	end
	
	-- Clear
	for i = #out, #a + 2, -1 do
		out [i] = nil
	end
	
	-- Carry
	out [#a + 1] = cf > 0 and cf or nil
	
	return out
end

function self:Multiply (b, out)
	local out = out or BigInteger ()
	local a = self
	
	-- Prepare for convolution
	for i = 1, #a + #b do
		out [i] = 0
	end
	
	-- Clear
	for i = #out, #a + #b + 1, -1 do
		out [i] = nil
	end
	
	-- Multiply
	for i = 1, #a do
		local high = 0
		for j = 1, #b do
			out [i + j - 1], high = UInt24.MultiplyAdd2 (a [i], b [j], out [i + j - 1], high)
		end
		
		-- Carry
		for j = i + #b, #a + #b do
			out [j], high = UInt24.Add (out [j], high)
			if high == 0 then break end
		end
	end
	
	-- Normalize
	for i = #out, 2, -1 do
		if out [i] ~= 0 then break end
		
		out [i] = nil
	end
	
	return out
end

function self:ToHex ()
	local t = {}
	
	t [1] = string_format ("%02x", self [#self])
	if #t [1] % 2 == 1 then
		t [1] = "0" .. t [1]
	end
	
	for i = #self - 1, 1, -1 do
		t [#t + 1] = string_format ("%06x", self [i])
	end
	
	return table_concat (t)
end

return BigInteger
