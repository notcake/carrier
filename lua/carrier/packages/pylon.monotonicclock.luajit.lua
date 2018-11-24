-- PACKAGE Pylon.MonotonicClock.LuaJIT

local ffi = require("ffi")

ffi.cdef("typedef long time_t;")

ffi.cdef(
	[[
		typedef struct timeval {
			time_t tv_sec;
			time_t tv_usec;
		} timeval;
	]]
)

ffi.cdef("int gettimeofday(struct timeval *t, void *tzp);")

return function()
	local t = ffi.new("struct timeval")
	local ret = ffi.C.gettimeofday(t, nil)
	if ret ~= 0 then error() end
	
	return tonumber(t.tv_sec) + tonumber(t.tv_usec) / 1000000
end
