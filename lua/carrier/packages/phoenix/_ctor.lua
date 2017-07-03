Phoenix = {}

Error = require ("Pylon.Error")

OOP = require ("Pylon.OOP")
OOP.Initialize (_ENV)

require_provider ("Phoenix.Core").Initialize (Phoenix)

include ("listview.lua")

return Phoenix
