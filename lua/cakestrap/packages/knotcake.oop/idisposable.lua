local self = {}
OOP.IDisposable = OOP.Class (self)

--[[
	Events:
		Disposed ()
			Fired when this object has been disposed.
]]

self.Disposed = OOP.Event ()

function self:ctor ()
	self._Disposed = false
end

function self:dtor ()
	self:Dispose ()
end

function self:Dispose ()
	if self:IsDisposed () then return end
	
	self._Disposed = true
	
	self.Disposed:Dispatch ()
	
	self:dtor ()
end

function self:IsDisposed ()
	return self._Disposed
end

function self:IsValid ()
	return not self._Disposed
end