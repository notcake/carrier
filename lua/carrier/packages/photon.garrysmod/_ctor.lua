GarrysMod = {}

require ("Pylon.OOP").Initialize (_ENV)

Color = require ("Pylon.Color")

Photon = require ("Photon")

Glass = require ("Glass")

include ("graphicscontext.lua")
include ("render2d.lua")
include ("render3d.lua")
include ("textrenderer.lua")

GarrysMod.GraphicsContext = GraphicsContext ()
GarrysMod.Render2d        = GarrysMod.GraphicsContext.Render2d
GarrysMod.Render3d        = GarrysMod.GraphicsContext.Render3d
GarrysMod.TextRenderer    = GarrysMod.GraphicsContext.TextRenderer

function GarrysMod.Initialize (destinationTable)
	destinationTable = destinationTable or {}
	
	Photon.Initialize (destinationTable)
	
	destinationTable.GraphicsContext = GarrysMod.GraphicsContext
	destinationTable.Render2d        = GarrysMod.Render2d
	destinationTable.Render3d        = GarrysMod.Render3d
	destinationTable.TextRenderer    = GarrysMod.TextRenderer
	
	return destinationTable
end

return GarrysMod
