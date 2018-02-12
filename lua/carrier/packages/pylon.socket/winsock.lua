local ffi = require ("ffi")

-- Adapted from https://github.com/carabalonepaulo/luajit-winsock/blob/master/src/winsock.lua
--[[
	Copyright (c) 2015, Paulo Fernando Linhares Carabalone
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
]]

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

ffi.cdef ("typedef unsigned short ushort;")
ffi.cdef ("typedef unsigned long ulong;")
ffi.cdef ("typedef unsigned int uint;")
ffi.cdef ("typedef unsigned char uchar;")
ffi.cdef ("typedef long SOCKET;")
ffi.cdef ("typedef unsigned char WORD;")

ffi.cdef ([[
	typedef struct {
		WORD           wVersion;
		WORD           wHighVersion;
		char           szDescription[256];
		char           szSystemStatus[129];
		unsigned short iMaxSockets;
		unsigned short iMaxUdpDg;
		char           *lpVendorInfo;
	} WSADATA, *LPWSADATA;
]])

ffi.cdef ([[
	typedef struct sockaddr {
		ushort sa_family;
		char sa_data[14];
	} sockaddr;
]])

ffi.cdef ([[
	typedef struct in_addr {
		union {
			struct {
				uchar s_b1, s_b2, s_b3, s_b4;
			} s_un_b;
			struct {
				ushort s_w1, s_w2;
			} s_un_w;
			uint s_addr;
		};
	} in_addr;
]])

ffi.cdef ([[
	typedef struct sockaddr_in {
		short sin_family;
		ushort sin_port;
		in_addr sin_addr;
		char sin_zero[8];
	} sockaddr_in;
]])

ffi.cdef ([[
	typedef struct addrinfo {
		int              ai_flags;
		int              ai_family;
		int              ai_socktype;
		int              ai_protocol;
		size_t           ai_addrlen;
		char             *ai_canonname;
		struct sockaddr  *ai_addr;
		struct addrinfo  *ai_next;
	} ADDRINFOA, *PADDRINFOA;
]])

ffi.cdef ("int WSAStartup(WORD wVersionRequested, LPWSADATA lpWSAData);")
ffi.cdef ("int WSACleanup(void);")
ffi.cdef ("int WSAGetLastError(void);")

ffi.cdef ("ushort htons(ushort hostshort);")

ffi.cdef ("int getaddrinfo (const char *pNodeName, const char *pServiceName, const ADDRINFOA *pHints, const PADDRINFOA *ppResult);")
ffi.cdef ("ulong inet_addr(const char *cp);")

ffi.cdef ("SOCKET socket(int af, int type, int protocol);")
ffi.cdef ("int connect(SOCKET s, const struct sockaddr *name, int namelen);")
ffi.cdef ("int send(SOCKET s, const char *buf, int len, int flags);")
ffi.cdef ("int recv(SOCKET s, char *buf, int len, int flags);")
ffi.cdef ("int closesocket(SOCKET s);")

local winsock = ffi.load ("ws2_32.dll")
Socket.WSAStartup      = winsock.WSAStartup
Socket.WSACleanup      = winsock.WSACleanup
Socket.WSAGetLastError = winsock.WSAGetLastError

Socket.htons           = winsock.htons

function Socket.getaddrinfo (host)
	local result = ffi.new ("ADDRINFOA *[1]")
	local ret = winsock.getaddrinfo (host, nil, nil, result)
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

Socket.inet_addr       = winsock.inet_addr

Socket.socket          = winsock.socket
Socket.connect         = winsock.connect
Socket.close           = winsock.closesocket

function Socket.read (socket, buffer, length)
	if type (buffer) == "number" or buffer == nil then
		local length = buffer or 4096
		local buffer = ffi.new ("char[?]", length)
		local length = winsock.recv (socket, buffer, length, 0)
		return ffi.string (buffer, length)
	else
		return winsock.recv (socket, buffer, length, 0)
	end
end

function Socket.write (socket, buffer, length)
	local length = length or #buffer
	return Socket.send (socket, buffer, length, 0)
end

local wsaData = ffi.new ("WSADATA")
assert (Socket.WSAStartup (0x202, wsaData) == 0)
