local self = {}
Socket.Tcp = Class(self)

local ffi = require("ffi")

function Socket.Tcp.Connect(host, port)
	local socket = Socket.Tcp()
	
	local addr = ffi.new("sockaddr_in")
	addr.sin_family      = Socket.AF_INET
	addr.sin_addr.s_addr = Socket.getaddrinfo(host)
	addr.sin_port        = Socket.htons(port)
	
	local ret = Socket.connect(socket.Socket, ffi.cast("const struct sockaddr *", addr), ffi.sizeof(addr))
	if ret == 0 then
		return socket
	else
		socket:Close()
		return nil
	end
end

function self:ctor()
	self.Socket = Socket.socket(Socket.AF_INET, Socket.SOCK_STREAM, Socket.IPPROTO_TCP)
	assert(self.Socket >= 0)
end

function self:Close()
	if not self.Socket then return end
	
	assert(Socket.close(self.Socket) == 0)
	self.Socket = nil
end

function self:Send(data)
	assert(Socket.write(self.Socket, data) == #data)
end

function self:Receive(length)
	return Socket.read(self.Socket, length)
end

function self:ReceiveLine(terminator)
	local terminator = terminator or "\n"
	local line = ""
	while true do
		local data = self:Receive(1)
		if not data then break end
		line = line .. data
		if string.sub(line, -#terminator) == terminator then
			line = string.sub(line, 1, -#terminator - 1)
			break
		end
	end
	
	return line
end
