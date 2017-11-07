-- PACKAGE Photon

Photon = {}

Error = require ("Pylon.Error")

OOP = require ("Pylon.OOP")
OOP.Initialize (_ENV)

include ("igraphicscontext.lua")
include ("irender2d.lua")
include ("irender3d.lua")
include ("itextrenderer.lua")

include ("itexture.lua")
include ("irendertarget.lua")

include ("glyph.lua")
include ("polygon.lua")

function Photon.Initialize (destinationTable)
	destinationTable = destinationTable or {}
	
	destinationTable.IGraphicsContext = Photon.IGraphicsContext
	destinationTable.IRender2d        = Photon.IRender2d
	destinationTable.IRender3d        = Photon.IRender3d
	destinationTable.ITextRenderer    = Photon.ITextRenderer
	
	destinationTable.ITexture         = Photon.ITexture
	destinationTable.IRenderTarget    = Photon.IRenderTarget
	
	destinationTable.Glyph            = Photon.Glyph
	destinationTable.Polygon          = Photon.Polygon
	
	return destinationTable
end

return Photon
