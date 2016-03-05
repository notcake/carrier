local self = {}
IO.IBaseStream = Class (self, IDisposable)

function self:ctor ()
end

function self:dtor ()
	self:Close ()
end

function self:Close ()
	Error ("IOutStream:Close : Not implemented.")
end

function self:GetPosition ()
	Error ("IOutStream:GetPosition : Not implemented.")
end

function self:GetSize ()
	Error ("IOutStream:GetSize : Not implemented.")
end

function self:SeekAbsolute (seekPos)
	Error ("IOutStream:SeekAbsolute : Not implemented.")
end

function self:SeekRelative (relativeSeekPos)
	self:SeekAbsolute (self:GetPosition () + relativeSeekPos)
end
