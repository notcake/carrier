Photon = {}

Error = require ("Pylon.Error")

OOP = require ("Pylon.OOP")
OOP.Initialize (_ENV)

require_provider ("Photon").Initialize (Photon)

return Photon
