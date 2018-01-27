local self = {}
Socket.Tcp = Class (self)

local ffi = require ("ffi")

function Socket.Tcp.Connect (host, port)
	local socket = Socket.Tcp ()
	
	local addr = ffi.new ("sockaddr_in")
	addr.sin_family      = WinSock.AF_INET
	addr.sin_addr.s_addr = WinSock.getaddrinfo (host)
	addr.sin_port        = WinSock.htons (port)
	
	local ret = WinSock.connect (socket.Socket, ffi.cast ("const struct sockaddr *", addr), ffi.sizeof (addr))
	if ret == 0 then
		return socket
	else
		socket:Close ()
		return nil
	end
end

function self:ctor ()
	self.Socket = WinSock.socket (WinSock.AF_INET, WinSock.SOCK_STREAM, WinSock.IPPROTO_TCP)
	assert (self.Socket >= 0)
end

function self:Close ()
	if not self.Socket then return end
	
	assert (WinSock.closesocket (self.Socket) == 0)
	self.Socket = nil
end

function self:Send (data)
	assert (WinSock.send (self.Socket, data, #data, 0) == #data)
end

function self:Receive (length)
	local length = length or 4096
	local buffer = ffi.new ("char[?]", length)
	local length = WinSock.recv (self.Socket, buffer, length, 0)
	return ffi.string (buffer, length)
end

function self:ReceiveLine (terminator)
	local terminator = "\n"
	local line = ""
	while true do
		local data = self:Receive (1)
		if not data then break end
		line = line .. data
		if string.sub (line, -#terminator) == terminator then break end
	end
	
	return line
end
