local self = {}
Lua.FileStream = Class(self, IO.IBaseStream)

function self:ctor(file)
	self.File = file
end

-- IBaseStream
function self:Close()
	if not self.File then return end
	
	self.File:flush()
	self.File:close()
	self.File = nil
end

function self:GetPosition()
	return self.File:seek()
end

function self:GetSize()
	local seekPos = self.File:seek()
	local size = self.File:seek("end")
	self.File:seek("set", seekPos)
	return size
end

function self:IsEndOfStream()
	return self.File:read(0) == nil
end

function self:SeekAbsolute(seekPos)
	seekPos = math.min(seekPos, self:GetSize())
	self.File:seek("set", seekPos)
end
