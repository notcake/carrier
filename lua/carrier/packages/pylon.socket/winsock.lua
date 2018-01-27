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

WinSock = {}
WinSock.AF_INET  =  2
WinSock.AF_INET6 = 23

WinSock.SOCK_STREAM    = 1
WinSock.SOCK_DGRAM     = 2
WinSock.SOCK_RAW       = 3
WinSock.SOCK_RDM       = 4
WinSock.SOCK_SEQPACKET = 5

WinSock.IPPROTO_TCP =  6
WinSock.IPPROTO_UDP = 17

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
	typedef struct {
		ushort sa_family;
		char sa_data[14];
	} sockaddr;
]])

ffi.cdef ([[
	typedef struct {
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
	typedef struct {
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
WinSock.WSAStartup      = winsock.WSAStartup
WinSock.WSACleanup      = winsock.WSACleanup
WinSock.WSAGetLastError = winsock.WSAGetLastError

WinSock.htons           = winsock.htons

function WinSock.getaddrinfo (host)
	local pResult = ffi.new ("ADDRINFOA *[1]")
	local ret = winsock.getaddrinfo (host, nil, nil, pResult)
	if ret < 0 then return nil end
	
	local result = pResult[0]
	while result ~= ffi.NULL do
		if result.ai_family == WinSock.AF_INET then
			return ffi.cast ("sockaddr_in *", result.ai_addr).sin_addr.s_addr;
		end
		result = result.ai_next
	end
	
	return nil
end

WinSock.inet_addr       = winsock.inet_addr

WinSock.socket          = winsock.socket
WinSock.connect         = winsock.connect
WinSock.send            = winsock.send
WinSock.recv            = winsock.recv
WinSock.closesocket     = winsock.closesocket

local wsaData = ffi.new ("WSADATA")
assert (WinSock.WSAStartup (0x202, wsaData) == 0)
