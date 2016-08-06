local self = {}
OOP.IDisposable = OOP.Class (self)

self.Disposed = OOP.Event ():SetDescription ("Fired when this object has been disposed.")

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
