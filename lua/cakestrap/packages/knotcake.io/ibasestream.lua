local self = {}
IO.IBaseStream = IO.Class (self, IO.IDisposable)

function self:ctor ()
end

function self:dtor ()
	self:Close ()
end

function self:Close ()
	IO.Error ("IOutStream:Close : Not implemented.")
end

function self:GetPosition ()
	IO.Error ("IOutStream:GetPosition : Not implemented.")
end

function self:GetSize ()
	IO.Error ("IOutStream:GetSize : Not implemented.")
end

function self:SeekAbsolute (seekPos)
	IO.Error ("IOutStream:SeekAbsolute : Not implemented.")
end

function self:SeekRelative (relativeSeekPos)
	self:SeekAbsolute (self:GetPosition () + relativeSeekPos)
end
