local self = {}
IO.IInputStream = Interface (self, IO.IBaseStream)

function self:ctor ()
end

function self:Read (length)
	Error ("IInputStream:Read : Not implemented.")
end

function self:ToStreamReader ()
	return IO.BufferedStreamReader (self)
end
