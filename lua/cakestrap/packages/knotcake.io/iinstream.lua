local self = {}
IO.IInStream = IO.Class (self, IO.IBaseStream)

function self:ctor ()
end

function self:Read (size)
	IO.Error ("IInStream:Read : Not implemented.")
end

function self:ToStreamReader ()
	return IO.BufferedStreamReader (self)
end
