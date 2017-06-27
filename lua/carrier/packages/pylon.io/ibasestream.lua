local self = {}
IO.IBaseStream = Interface (self, IDisposable)

function self:ctor ()
end

function self:dtor ()
	self:Close ()
end

function self:Close ()
	Error ("IBaseStream:Close : Not implemented.")
end

function self:GetPosition ()
	Error ("IBaseStream:GetPosition : Not implemented.")
end

function self:GetSize ()
	Error ("IBaseStream:GetSize : Not implemented.")
end

function self:SeekAbsolute (seekPos)
	Error ("IBaseStream:SeekAbsolute : Not implemented.")
end

function self:SeekRelative (relativeSeekPos)
	self:SeekAbsolute (self:GetPosition () + relativeSeekPos)
end
