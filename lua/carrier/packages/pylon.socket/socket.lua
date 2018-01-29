local ffi = require ("ffi")

Socket = {}
Socket.AF_INET  =  2
Socket.AF_INET6 = 23

Socket.SOCK_STREAM    = 1
Socket.SOCK_DGRAM     = 2
Socket.SOCK_RAW       = 3
Socket.SOCK_RDM       = 4
Socket.SOCK_SEQPACKET = 5

Socket.IPPROTO_TCP =  6
Socket.IPPROTO_UDP = 17

ffi.cdef ("typedef uint32_t socklen_t;")
ffi.cdef ("typedef unsigned short int sa_family_t;")
ffi.cdef ("typedef uint16_t in_port_t;")
ffi.cdef ("typedef uint32_t in_addr_t;")

ffi.cdef ([[
	typedef struct sockaddr {
		sa_family_t sin_family;
		char sa_data[14];
	} sockaddr;
]])

ffi.cdef ([[
	typedef struct in_addr {
		in_addr_t s_addr;
	} in_addr;
]])

ffi.cdef ([[
	typedef struct sockaddr_in {
		sa_family_t sin_family;
		in_port_t sin_port;
		struct in_addr sin_addr;

		/* Pad to size of `struct sockaddr'.  */
		unsigned char sin_zero[sizeof(struct sockaddr) -
			sizeof(sa_family_t) -
			sizeof(in_port_t) -
			sizeof(struct in_addr)];
	} sockaddr_in;
]])

ffi.cdef ([[
	typedef struct addrinfo {
		int              ai_flags;
		int              ai_family;
		int              ai_socktype;
		int              ai_protocol;
		socklen_t        ai_addrlen;
		struct sockaddr *ai_addr;
		char            *ai_canonname;
		struct addrinfo *ai_next;
	} addrinfo;
]])

ffi.cdef ("uint16_t htons(uint16_t hostshort);")

ffi.cdef ("int getaddrinfo (const char *nodename, const char *servname, const addrinfo *hints, const addrinfo **res);")
ffi.cdef ("in_addr_t inet_addr(const char *);")

ffi.cdef ("int socket(int af, int type, int protocol);")
ffi.cdef ("int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);")
ffi.cdef ("int close(int fd);")

ffi.cdef ("typedef int ssize_t;")
ffi.cdef ("ssize_t read(int fd, void *buf, size_t count);")
ffi.cdef ("ssize_t write(int fd, const void *buf, size_t count);")

Socket.htons   = ffi.C.htons

function Socket.getaddrinfo (host)
	local result = ffi.new ("const addrinfo *[1]")
	local ret = ffi.C.getaddrinfo (host, nil, nil, result)
	if ret < 0 then return nil end
	
	local result = result[0]
	while result ~= ffi.NULL do
		if result.ai_family == Socket.AF_INET then
			return ffi.cast ("sockaddr_in *", result.ai_addr).sin_addr.s_addr;
		end
		result = result.ai_next
	end
	
	return nil
end

Socket.inet_addr = ffi.C.inet_addr

Socket.socket    = ffi.C.socket
Socket.connect   = ffi.C.connect
Socket.close     = ffi.C.close

function Socket.read (socket, buffer, length)
	if type (buffer) == "number" or buffer == nil then
		local length = buffer or 4096
		local buffer = ffi.new ("char[?]", length)
		local length = ffi.C.read (socket, buffer, length)
		return ffi.string (buffer, length)
	else
		return ffi.C.read (socket, buffer, length)
	end
end

function Socket.write (socket, buffer, length)
	local length = length or #buffer
	return ffi.C.write (socket, buffer, length)
end
