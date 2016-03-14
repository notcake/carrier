local self = {}
IO.IOutStream = Class (self, IO.IBaseStream)

function self:ctor ()
end

function self:Write (data, length)
	Error ("IOutStream:Write : Not implemented.")
end

function self:ToStreamWriter ()
	return IO.BufferedStreamWriter (self)
end
