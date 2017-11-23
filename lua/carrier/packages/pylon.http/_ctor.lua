-- PACKAGE Pylon.HTTP

HTTP = {}

Error = require ("Pylon.Error")

OOP = require ("Pylon.OOP")
OOP.Initialize (_ENV)

include ("httpcodes.lua")
include ("httpresponse.lua")

local encodeMap = {}
local decodeMap = {}
for i = 0, 255 do
	encodeMap [string.char (i)] = string.format ("%%%02X", i)
	decodeMap [string.format ("%%%02x", i)] = string.char (i)
	decodeMap [string.format ("%%%02X", i)] = string.char (i)
end

function HTTP.EncodeUriComponent (s)
	return string.gsub (s, "[^A-Za-z0-9%-_%.!~%*'%(%)]", encodeMap)
end

function HTTP.DecodeUriComponent (s)
	return string.gsub (s, "%%[a-fA-F0-9][a-fA-F0-9]", decodeMap)
end

function HTTP.Get (url)
	Error ("HTTP.Get : Not implemented.")
end

function HTTP.Post (url, parameters)
	Error ("HTTP.Post : Not implemented.")
end

function HTTP.Initialize (destinationTable)
	destinationTable = destinationTable or {}
	
	destinationTable.HTTPCodes          = HTTP.HTTPCodes
	destinationTable.HTTPResponse       = HTTP.HTTPResponse
	
	destinationTable.EncodeUriComponent = HTTP.EncodeUriComponent
	destinationTable.DecodeUriComponent = HTTP.DecodeUriComponent
	
	destinationTable.Get                = HTTP.Get
	destinationTable.Post               = HTTP.Post
	
	return destinationTable
end

return HTTP
