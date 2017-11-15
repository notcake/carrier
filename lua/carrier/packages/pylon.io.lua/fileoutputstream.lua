local self = {}
Lua.FileOutputStream = Class (self, Lua.FileStream, IO.IOutputStream)

function Lua.FileOutputStream.FromPath (path)
	local f = io.open (path, "wb")
	if not f then return nil end
	
	return Lua.FileOutputStream (f)
end

function self:ctor (file)
end

-- IOutputStream
function self:Write (data, length)
	length = length or #data
	
	if length < #data then
		data = string.sub (data, 1, length)
	end
	
	self.File:write (data)
end
