-- PACKAGE Photon.GarrysMod

GarrysMod = {}

require("Pylon.OOP").Initialize(_ENV)

Color = require("Pylon.Color")

Photon = require("Photon")
Photon.Initialize(GarrysMod)

Cat = require("Cat")

Glass = require("Glass")

FontCache = require("GarrysMod.FontCache")

include("polygonbuffer.lua")

include("graphicscontext.lua")
include("render2d.lua")
include("render3d.lua")
include("textrenderer.lua")

include("texture.lua")
include("rendertarget.lua")

include("glyphrenderer.lua")

if CLIENT then
	GarrysMod.GraphicsContext = GraphicsContext()
	GarrysMod.Render2d        = GarrysMod.GraphicsContext.Render2d
	GarrysMod.Render3d        = GarrysMod.GraphicsContext.Render3d
	GarrysMod.TextRenderer    = GarrysMod.GraphicsContext.TextRenderer
end

function GarrysMod.Initialize(destinationTable)
	destinationTable = destinationTable or {}
	
	Photon.Initialize(destinationTable)
	
	destinationTable.GraphicsContext = GarrysMod.GraphicsContext
	destinationTable.Render2d        = GarrysMod.Render2d
	destinationTable.Render3d        = GarrysMod.Render3d
	destinationTable.TextRenderer    = GarrysMod.TextRenderer
	
	return destinationTable
end

return GarrysMod
