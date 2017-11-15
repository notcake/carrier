local self = {}
Lua.FileInputStream = Class (self, Lua.FileStream, IO.IInputStream)

function Lua.FileInputStream.FromPath (path)
	local f = io.open (path, "rb")
	if not f then return nil end
	
	return Lua.FileInputStream (f)
end

function self:ctor (file)
end

-- IInputStream
function self:Read (length)
	return self.File:read (length) or ""
end
