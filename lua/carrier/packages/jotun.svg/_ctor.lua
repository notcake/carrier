-- PACKAGE Jotun.Svg

Svg = {}

Error = require ("Pylon.Error")

require ("Pylon.OOP").Initialize (_ENV)

require ("Pylon.Enumeration").Initialize (_ENV)

ICollection = require ("Pylon.Containers.ICollection")

Xml = require ("Jotun.Xml")

Color = require ("Pylon.Color")

Cat = require ("Cat")

Photon = require ("Photon")
Glass  = require ("Glass")

StringParser = require ("Eka.StringParser")

include ("image.lua")
include ("element.lua")
include ("path.lua")
include ("pathcommand.lua")
include ("pathparser.lua")
include ("polygon.lua")
include ("text.lua")

return Svg
