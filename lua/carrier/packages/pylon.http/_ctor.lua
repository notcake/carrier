-- PACKAGE Pylon.HTTP

HTTP = {}

Error = require ("Pylon.Error")

OOP = require ("Pylon.OOP")
OOP.Initialize (_ENV)

include ("httpcodes.lua")
include ("httpresponse.lua")

function HTTP.Get (url)
	Error ("HTTP.Get : Not implemented.")
end

function HTTP.Post (url, parameters)
	Error ("HTTP.Post : Not implemented.")
end

function HTTP.Initialize (destinationTable)
	destinationTable = destinationTable or {}
	
	destinationTable.HTTPCodes    = HTTP.HTTPCodes
	destinationTable.HTTPResponse = HTTP.HTTPResponse
	
	destinationTable.Get          = HTTP.Get
	destinationTable.Post         = HTTP.Post
	
	return destinationTable
end

return HTTP
